#!/usr/bin/env ruby
#encoding: utf-8
require 'net/http'
$use_internet = true # Интернет пока что даёт _намного_ лучшие результаты
class Translator
 def initialize (log)
  @translation="".force_encoding("UTF-8")
  @log = log
 end
 def process(word)
  if ($use_internet) then
   req = Net::HTTP::Get.new('http://mymemory.translated.net/api/get?q='+word+'&langpair=en|ru&of=tmx')
   begin
    res = Net::HTTP.start('mymemory.translated.net',80) {|http|http.request(req)}
   rescue SocketError,Timeout::Error
    @log << "Отсутствует соединение с Интернетом."
    $use_internet = false
    return process(word)
   end
   res.body.match(/RU.*<seg>(.*)<\/seg>/m)
   temp = $1
   # Если вернули больше одного слова — берём первое. Это чтобы целыми фразами не оперировать, транслятор может быть эпически туп.
   temp.gsub!(/&\w*;/,"")
   if temp.match(/\s/) then
    temp = temp.split(/\s/).at(0)
   end
   @translation = temp
  else
#   beginning = word[0..1].downcase
#   if beginning.length==1 then beginning = beginning+"-" end
#   start_from = 0
#   File.open("Mueller/Mueller.hash", File::RDONLY).each_line { |line|
#    if line =~ /^#{beginning}/ then
#     line.match(/^#{beginning}(\d+)/)
#     start_from = $1
#     break
#    end
#   }
#   word.downcase!
   #здесь ОЧЕНЬ выгодно было бы получать инфинитив слова
   accents = {
    "ó" => "o",
    "á" => "a",
    "´" => "",
    "é" => "e",
    "í" => "i",
    "ú" => "u",
    "ý" => "y",
    'ied\b' => "y", #да, хаки
    'led\b' => "le",#грязные
    'ed\b' => "",
    "," => "",
    '\.' => "",
    ";" => "",
    '\bthe\b' => "",
    '\ba\b' => ""
   }
   accents.each do |key, value|
    word.gsub!(/#{key}/,value)
   end
   if word.empty? then return true end
   Dir.new("dictionaries").entries.each do |entry|
   if entry.match(/.txt/) then File.open("dictionaries/"+entry, File::RDONLY) do |dictionary|
#    dictionary.seek(start_from.to_i, IO::SEEK_SET)
#    dictionary.readline
    dictionary.each_line{ |line|
     if line.match(/^  /) then next end
     if line.match(/^#{word}\b/i) then
      return dictionary.readline.scan(/^  (.*)/).at(0).at(0)#возвращаем только один вариант — но достаточно
     end
#     if line.match(/^#{word}\b  (?:_\w+(?:\.|:) )?(?:(?:_\w|\d(?:\.|>)) )?(\D+)/) then
#      return $1 #из многих вариантов выберем первый
#     end
    }
   end
   end
   end #if entry.match
   puts word
   @translation = false
  end #end if $use_internet
 #Google Translate — отключено, т.к. меня забанили
 # require 'rtranslate/rtranslate'
 # @key = "ABQIAAAA10fXG_CwfNZvQrP8C4erpRROsGTYQpPXiD84IdgAaAE76vGUDRRbu7nAcYQWlyYOMdeZGrJ7EPC5_A" #ключ Google Translate. Действителен на localhost.
 # @translation = Translate.t(word, nil, "RUSSIAN")
#зд. важно: Google Translate не поддерживает перевода с эсперанто. А в любом другом языке ударение не фиксированное.

#  letter = word[0].chr.downcase!
#  if (word[1].chr!='x')
#   filename = 'dictionary/'+letter+'.txt'
#  else
#   filename = 'dictionary/'+letter+'x.txt'
#  end
#  begin
#   dictionary = File.open(filename, 'r')
#   rescue
#    puts filename
#    @log << "Невозможно открыть файл словаря: #{filename}\n"
#    next
#   end
#   @root = ''
#   dictionary.each do |line|
#   if line[0].chr!='['
#    next
#   end
#   line.gsub!('~', @root)
#   line.match(/(\w+)(\||\/)/)
#   if $1
#    @root = $1
#   end
#   if word.match(@root)
#    line.gsub!('_.*_','_')
#    @translated_words[word]=line.scan(/\] ([\w`]+)/).first;
#    @log << @translated_words[word]
#   end
#  end
  return @translation
 end
end
