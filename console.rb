#!/usr/bin/env ruby
#encoding: utf-8
#Консольный интерфейс. Не правда ли, намного проще? :-)
$rlyDEBUG = true
$:.unshift File.dirname(__FILE__) #добавить текущую директорию к $LOAD_FILE - чтобы не вызывать ruby -I.
require "source.rb"
class Log
 def << (string) puts string end
end
@log = Log.new;
#$source = Source.new("Dankon pro la mondkreintoj\nkiuj per heroestimo\ndonos al ni pliegigon\nlaux verkitaj plimensiloj.",@log)
$source = Source.new("I ásked no óther thing,\nNo óther was deníed.\nI óffered Béing for it;\nThe míghty mérchant smíled.",@log)#Эмили Дикинсон
#заметьте: в слове denied ударение на второй слог, в слове offered — на первый
$source.find_rhymes()
$source.replace()
result = $source.translate()
if result != false then
 $source.arrange()
 @log << $source.print()
end
