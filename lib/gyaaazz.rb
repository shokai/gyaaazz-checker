# -*- coding: utf-8 -*-
require 'rubygems'
require 'json'
require 'open-uri'
require 'kconv'
require 'uri'
require 'diff/lcs'

class Gyaaazz
  
  def initialize(url)
    url = url.scan(/(.+)\//).first.first if url =~ /\/$/
    @url = url
  end

  def search(word=nil)
    word = '.*' unless word
    JSON.parse open(URI.encode "#{@url}/api/search.json?word=#{word}").read.toutf8
  end

  def get(name)
    JSON.parse open(URI.encode "#{@url}/#{name}.json").read.toutf8
  end

  def diff(a, b)
    diffs = Diff::LCS.sdiff(a['lines'], b['lines'])
    changed = false
    result = Array.new
    diffs.each{|d|
      if d.old_element == d.new_element
        result << " #{d.old_element}"
      else
        result << "-#{d.old_element}" if d.old_element and d.old_element.size>0
        result << "+#{d.new_element}" if d.new_element and d.new_element.size>0
        changed = true
      end
    }
    return changed, str
  end

  def newlines(a, b)
    diffs = Diff::LCS.sdiff(a['lines'], b['lines'])
    new_lines = Array.new
    diffs.each{|d|
      next if d.old_element == d.new_element
      line = d.new_element.to_s
      new_lines << line if line.size > 0 and !(line =~ /^\s+$/)
    }
    new_lines
  end
end


if __FILE__ == $0
  url = 'http://dev.shokai.org/gyaaazz/'
  url = ARGV.first if ARGV.size > 0
  g = Gyaaazz.new(url)
  p pages = g.search
  p g.get(pages.first['name'])
end
