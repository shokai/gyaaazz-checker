#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'im-kayac'
require 'json'
require 'yaml'
require 'tokyocabinet'
include TokyoCabinet
$KCODE = 'u'

Dir.glob(File.dirname(__FILE__)+'/lib/*.rb').each{|f|
  require f
}

begin
  conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
end

begin
  db = HDB.new
  db.open(File.dirname(__FILE__)+"/pages.tch", HDB::OWRITER|HDB::OCREAT)
rescue => e
  STDERR.puts e
end

['gyaaazz', 'urlmemo'].each{|i|
  conf[i] = conf[i].scan(/(.+)\//).first.first if conf[i] =~ /\/$/
}

g = Gyaaazz.new(conf['gyaaazz'])
u = UrlMemo.new(conf['urlmemo'])

pages = g.search
pages[0...20].each{|page|
  data = g.get(page['name'])
  if data['error']
    STDERR.puts "gyaaazz get data error"
    STDERR.puts data['message']
  else
    if db[page['name']] == nil
      begin
        db[page['name']] = data.to_json
        p data
        res = u.add(:url => "#{conf['gyaaazz']}/#{data['name']}",
                    :title => "gyaaazz/#{data['name']}")
        mes = "newpage 【#{data['name']}】 #{conf['urlmemo']}/#{res['name']} #{data['lines'].first}}"
        ## tw.update unless conf['no_tweet']
        puts mes[0...140] + "(twitter)"
        lines = data['lines'].join("\n")
        conf['im_kayac_users'].each{|im_user|
          ImKayac.post(im_user, "newpage #{res['url']}\n #{lines}")
        }
      rescue => e
        STDERR.puts e
      end
    else
      begin
        newlines = g.newlines(JSON.parse(db[data['name']]), data)
        db[data['name']] = data.to_json if newlines.size > 0
        res = u.add(:url => "#{conf['gyaaazz']}/#{data['name']}",
                    :title => "gyaaazz/#{data['name']}")
        p res
        for i in 0...newlines.size do
          puts line = newlines[i]
          conf['im_kayac_users'].each{|im_user|
            ImKayac.post(im_user, "#{res['url']}\n #{line}")
          }
          next if i > 1 # 2 tweet per 1 page
          mes = "【#{data['name']}】 #{conf['urlmemo']}/#{res['name']} #{line}"
          # twitter update unless conf['no_tweet']
          puts mes[0...140] + "(twitter)"
          sleep 5
        end
      rescue => e
        STDERR.puts e
      end
    end
  end
  sleep 3
}

db.close
