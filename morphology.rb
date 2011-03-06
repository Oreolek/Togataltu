#!/usr/bin/env ruby
#encoding: utf-8
require 'net/http'
require 'uri'
class Morphology
 def initialize (log)
  @word = "".force_encoding("UTF-8")
  @log = log
 end
 def process(word)
  #res = Net::HTTP.post_form( URI.parse('http://www.morphology.ru/'), { "word" => URI.escape("#{word}")})
  #returning = res.body.scan(/<li>(\w+)<\/li>/)
  #if returning.empty? then return false end
  #return returning
  res = %x[php phpmorphy/cli.php "#{word}"].encode("UTF-8")
  if res.match("Error") then return false end
  return res.split(", ")
 end
end
