# -*- coding: utf-8 -*-
require 'rubygems'
require 'net/http'
require 'uri'
require 'json'

class UrlMemo
  
  def initialize(api_url)
    @api_uri = URI.parse api_url
  end

  def add(params)
    query = params.map{|k,v|
      "#{k}=#{v}"
    }.join('&')
    res = nil
    Net::HTTP.start(@api_uri.host, @api_uri.port){|http|
      res = http.post(@api_uri.path, query)
    }
    return JSON.parse(res.body)
  end
end

if __FILE__ == $0
  u = UrlMemo.new 'http://localhost:8087/'
  res = u.add(:url => 'http://shokai.org/blog/',
              :title => 'shokai blog')
  p res
end
