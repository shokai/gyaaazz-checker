# -*- coding: utf-8 -*-
require 'rubygems'
require 'json'
require 'open-uri'
require 'kconv'
require 'uri'

class Gyaaazz
  
  def initialize(url)
    url = url.scan(/(.+)\//).first.first if url =~ /\/$/
    @url = url
  end

  def search(word=nil)
    JSON.parse open(URI.encode "#{@url}/api/search.json?word=#{word}").read.toutf8
  end

  def get(name)
    JSON.parse open(URI.encode "#{@url}/#{name}.json").read.toutf8
  end
end


if __FILE__ == $0
  url = 'http://dev.shokai.org/gyaaazz/'
  url = ARGV.first if ARGV.size > 0
  g = Gyaaazz.new(url)
  p pages = g.search
  p g.get(pages.first['name'])
end
