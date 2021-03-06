#!/usr/bin/env ruby
#encoding: utf-8
require "translator.rb"
require "morphology.rb"
require "stack.rb"
class Source
 def initialize (text,log)
    @text = text.encode("UTF-8")
    @log = log
    @translation = ""
    @pattern = ""
    @rhymed = Hash.new
    @translated_words = Stack.new
    
    @text.each_line do |line|
     if line.empty? then next end
     line.downcase.split.each do |word|
      vowels = word.count("aeioyuáéíóúý´")
      if (vowels==1) then #в односложных словах всё тривиально
       @pattern << "!"
       unless word.match(/[áéíóúý´]/) then #знак ударения не проставлен, но гласная единственная — проставляем
        {"a" => "á","e" => "é","i" => "í","u" => "ú","y" => "ý"}.each do |key, value| word.gsub!(key,value) end
       end #end unless
       next
      end #if vowels == 1
      word.each_char do |char|
       if (char.match(/[áéíóúý´]/)) then @pattern = @pattern+"!"
       elsif (char.match(/[aeioyu]/)) then @pattern = @pattern+"-"
       end
      end #each char in word
      #@pattern = @pattern + " "
     end #each word in line
     @pattern = @pattern + "\n"
    end #@text.each_line
  end
  def find_rhymes()
   this_line_number = 0
   @text.each_line do |line|
    this_line_number = this_line_number + 1
    this_last_vowel = line.split.at(-1).scan(/[áéíóúý]|\w´/)
    other_line_number = 0
    @text.each_line do |line_other|
     other_line_number = other_line_number + 1
     if other_line_number == this_line_number then next end
     other_last_vowel = line_other.split.at(-1).scan(/[áéíóúý]|\w´/)
     if other_last_vowel = this_last_vowel then 
      matched_vowels = 1
      if line.split.at(-2).scan(/[áéíóúý]|\w´/) == line_other.split.at(-2).scan(/[áéíóúý]|\w´/) then matched_vowels = 2 end #можно сделать и так далее, но не стоит, наверное
      if @rhymed[this_line_number].nil? then @rhymed[this_line_number] = Hash.new end
      @rhymed[this_line_number][other_line_number] = matched_vowels
     end
    end
   end
#   @log << @rhymed.to_s
  end
  def replace()
    phrases = {
      "l'" => "la",
      "o´" => "ó",
      "a´" => "á",
      "e´" => "é",
      "i´" => "í",
      "u´" => "ú",
      "y´" => "ý"
    }
    phrases.each do |key, value|
      @text.gsub!(/#{key}/,value)
    end
  end
  def translate()
    translator = Translator.new(@log);
    @text.split.each do |word|
      word_translation = translator.process(word)
      if word_translation == true then next end
      if word_translation != false then
       @translated_words.push(word_translation)
      else
       @log << "Перевод не удался. Прекращение работы."
       return false
      end
    end
  end
  def arrange()
   morphology = Morphology.new(@log);
#   @text.downcase.split.each do |word|
#    vowels = word.count("аеиоуыэюяё")
#    met_vowels = 0
#    piece = "" #текущий слог
#    index = 0
#    while (met_vowels <= vowels and word[index]) do
#     if word[index] =~ /[аеиоуыэюяё]/ then
#      met_vowels = met_vowels+1
#      if piece.match("аеиоуыэюяё") then #на один слог может быть только одна гласная
#       check_piece(piece)
#       piece = word[index]
#      end
#     end
#     piece = piece + word[index].to_s
#     index = index + 1
#    end
#   end
   @log << "Паттерн:\n"
   @log << @pattern
   line_number = 0
   @pattern.each_line do |pattern_line|
    if (@translated_words.count() == 0) then break end
    pattern_index = 0
    line_number = line_number + 1
    while (pattern_index < pattern_line.size and @translated_words.count() > 0) do
     word = @translated_words.pop()
     forms = morphology.process(word)
     if (forms == false) then
      #@translation << word .. " "
      #pieces = 0
      #word.scan(/[аеиоуыэюяё]/) { pieces += 1}
      #pattern_index = pattern_index + pieces
      next
     end
     forms_result = Array.new()
     # TODO: если слово — последнее в строке или предпоследнее, то отсеиваем все не рифмующиеся (плохо рифмующиеся) словоформы. Если ничего не осталось — не отсеиваем.
     forms.each do |form|
      forms_result.push(check_pattern(form, pattern_line,pattern_index))
      #TODO: forms_result надо сделать хэшем массивов и сортировать по ключам. Выбирать любой вариант из полученного массива.
     end
     form_index = 0
     forms_result.each do |result|
      if result <= 12 then 
       @translation << forms[form_index] + " "
       pieces = 0
       forms[form_index].scan(/[аеиоуыэюяё]/) { pieces += 1}
       pattern_index = pattern_index + pieces
       break
      end
      form_index += 1
     end
    end
    @translation << "\n"
   end
  end
  private
  def check_pattern(word, pattern, index) #проверяет соответствие слова паттерну; возвращает 0, если слово вписывается и число, если не вписывается
   word_pattern = ""
   piece = ""
   word.to_s.each_char do |char|
     if char =~ /[аеиоуыэюяё]/ then
      if piece =~ /[аеиоуыэюяё]/ then
       word_pattern << check_piece(piece)
       piece = char
      end
     end
     piece = piece + char
    end
   pattern_index = index #или index+1?
   result = 0
   word_pattern.each_char do |char|
    if char == '-' and pattern[pattern_index]=='!' then
     result = result + 2 #безударные слоги не могут стать ударными - см. главу 1
    end
    if char == '!' and pattern[pattern_index]=='-' then
     result = result + 1
    end
    pattern_index = pattern_index + 1
   end
   return result
  end
  #проверка русских слогов на ударение
  def check_piece(piece)
   probability_acute_sec={
     "все"=>0.14,
     "че"=>0.0675,
     "ква"=>0.0375,
     "ме"=>0.0275,
     "ми"=>0.025,
     "ви"=>0.0175,
     "ак"=>0.015,
     "сле"=>0.01,
     "на"=>0.01,
     "ки"=>0.01,
     "не"=>0.01,
     "ра"=>0.01,
    }
   probability_acute={
     "ве"=>0.0255724374063771,
     "по"=>0.0209715386261502,
     "го"=>0.0206505456879949,
     "вы"=>0.017547613952493,
     "до"=>0.0117697410656966,
     "са"=>0.0114487481275412,
     "во"=>0.0111277551893858,
     "сто"=>0.0106997646051787,
     "ма"=>0.00802482345388401,
     "ко"=>0.00727583993152151,
     "ду"=>0.00706184463941793,
     "те"=>0.00674085170126257,
     "ме"=>0.006526856409159,
     "бо"=>0.006526856409159,
     "на"=>0.00641985876310721,
     "де"=>0.00588487053284828,
     "то"=>0.00588487053284828,
     "ра"=>0.00534988230258934,
     "за"=>0.00513588701048577,
     "мо"=>0.00513588701048577,
     "ка"=>0.00513588701048577,
     "це"=>0.00502888936443398,
     "па"=>0.00502888936443398,
     "ли"=>0.00481489407233041,
     "сте"=>0.00449390113417505,
     "ви"=>0.00449390113417505,
     "пра"=>0.00449390113417505,
     "пе"=>0.00449390113417505,
     "сло"=>0.00438690348812326,
     "про"=>0.00427990584207147,
     "но"=>0.0040659105499679,
     "ре"=>0.00395891290391611,
     "гла"=>0.00374491761181254,
     "ла"=>0.00363791996576075,
     "су"=>0.00363791996576075,
     "ле"=>0.00363791996576075,
     "зе"=>0.00363791996576075,
     "стра"=>0.00363791996576075,
     "со"=>0.00353092231970897,
     "зна"=>0.00353092231970897,
     "пи"=>0.00353092231970897,
     "се"=>0.00342392467365718,
     "тре"=>0.00342392467365718,
     "хо"=>0.00331692702760539,
     "при"=>0.00320992938155361,
     "ска"=>0.00320992938155361,
     "не"=>0.00320992938155361,
     "ро"=>0.00320992938155361,
     "чи"=>0.00299593408945003,
     "бе"=>0.00299593408945003,
     "ча"=>0.00299593408945003,
     "ва"=>0.00288893644339825,
     "кру"=>0.00267494115129467,
     "ми"=>0.00256794350524288,
     "пу"=>0.0024609458591911,
     "ты"=>0.00235394821313931,
     "ру"=>0.00213995292103574,
     "же"=>0.00213995292103574,
     "да"=>0.00203295527498395,
     "че"=>0.00203295527498395,
     "зме"=>0.00203295527498395,
     "ста"=>0.00192595762893216,
     "жа"=>0.00192595762893216,
     "ну"=>0.00192595762893216,
     "ку"=>0.00181895998288038,
     "ге"=>0.00181895998288038,
     "кра"=>0.00181895998288038,
     "си"=>0.00181895998288038,
     "тра"=>0.00181895998288038,
     "ба"=>0.00181895998288038,
     "ти"=>0.00181895998288038,
     "ха"=>0.00181895998288038,
     "гра"=>0.00171196233682859,
     "тру"=>0.00171196233682859,
     "та"=>0.0016049646907768,
     "бу"=>0.0016049646907768,
     "га"=>0.0016049646907768,
     "тро"=>0.0016049646907768,
     "чу"=>0.00149796704472502,
     "тю"=>0.00149796704472502,
     "хло"=>0.00149796704472502,
     "ни"=>0.00139096939867323,
     "му"=>0.00139096939867323,
     "ту"=>0.00139096939867323,
     "цве"=>0.00128397175262144,
     "ло"=>0.00128397175262144,
     "кла"=>0.00128397175262144,
     "зо"=>0.00128397175262144,
     "ке"=>0.00117697410656966,
     "фо"=>0.00106997646051787,
     "сме"=>0.00106997646051787,
     "мэ"=>0.00106997646051787,
     "ша"=>0.00106997646051787,
     "пла"=>0.00106997646051787,
     "све"=>0.00106997646051787,
     "ки"=>0.00106997646051787,
    }
   probability_no = {
     "от"=>0.0443044406056295,
     "дев"=>0.0436947464688548,
     "ятс"=>0.0409307997154761,
     "ов"=>0.0121938827354944,
     "ом"=>0.0120516207702469,
     "ат"=>0.0112386952545473,
     "цат"=>0.00945025912000813,
     "од"=>0.0088608881211259,
     "ал"=>0.00780408495071639,
     "ог"=>0.00766182298546896,
     "мин"=>0.00709277512447922,
     "ит"=>0.00646275784981201,
     "ан"=>0.00640178843613454,
     "ут"=>0.00597500254039224,
     "он"=>0.00534498526572503,
     "ор"=>0.00526369271415507,
     "ет"=>0.00481658368052027,
     "ен"=>0.00481658368052027,
     "ид"=>0.00449141347424042,
     "ок"=>0.00438979778477797,
     "ят"=>0.00434915150899299,
     "ер"=>0.00430850523320801,
     "ес"=>0.00414592013006808,
     "ин"=>0.00414592013006808,
     "ка"=>0.0041052738542831,
     "ни"=>0.00408495071639061,
     "ол"=>0.00400365816482065,
     "ил"=>0.00400365816482065,
     "ла"=>0.00363784168275582,
     "ый"=>0.00347525657961589,
     "ел"=>0.00339396402804593,
     "сто"=>0.00317040951122853,
     "ой"=>0.0030281475459811,
     "ос"=>0.00300782440808861,
     "ты"=>0.00292653185651865,
     "им"=>0.00284523930494868,
     "ев"=>0.00276394675337872,
     "сам"=>0.00272330047759374,
     "ик"=>0.00268265420180876,
     "пер"=>0.00268265420180876,
     "нач"=>0.00256071537445382,
     "ем"=>0.00254039223656133,
     "дес"=>0.00249974596077634,
     "ар"=>0.00235748399552891,
     "оп"=>0.00231683771974393,
     "ав"=>0.00229651458185144,
     "ам"=>0.00225586830606646,
     "ир"=>0.00225586830606646,
     "том"=>0.00213392947871151,
     "ак"=>0.00209328320292653,
     "ив"=>0.00207296006503404,
     "пол"=>0.00199166751346408,
     "об"=>0.00197134437557159,
     "чет"=>0.0019510212376791,
     "ед"=>0.00193069809978661,
     "тых"=>0.00186972868610914,
     "ис"=>0.00184940554821664,
     "ва"=>0.00178843613453917,
     "ад"=>0.00178843613453917,
     "ятн"=>0.00176811299664668,
     "ать"=>0.00174778985875419,
     "пят"=>0.00174778985875419,
     "ны"=>0.00164617416929174,
     "дор"=>0.00164617416929174,
     "сор"=>0.00162585103139925,
     "век"=>0.00160552789350676,
     "ли"=>0.00152423534193679,
     "ур"=>0.00152423534193679,
     "ах"=>0.0015039122040443,
     "ей"=>0.00144294279036683,
     "ич"=>0.00142261965247434,
     "ек"=>0.00134132710090438,
     "те"=>0.00134132710090438,
     "дом"=>0.00132100396301189,
     "ул"=>0.00132100396301189,
     "гор"=>0.0013006808251194,
     "етр"=>0.0013006808251194,
     "ян"=>0.00128035768722691,
     "та"=>0.00128035768722691,
     "ду"=>0.00128035768722691,
     "аб"=>0.00121938827354944,
     "ас"=>0.00121938827354944,
     "душ"=>0.00119906513565695,
     "на"=>0.00119906513565695,
     "ант"=>0.00119906513565695,
     "ма"=>0.00117874199776445,
     "сем"=>0.00115841885987196,
     "оз"=>0.00115841885987196,
     "две"=>0.00115841885987196,
     "ост"=>0.00115841885987196,
     "ры"=>0.00111777258408698,
     "за"=>0.00111777258408698,
     "ров"=>0.00111777258408698,
     "нац"=>0.00111777258408698,
     "ых"=>0.00109744944619449,
     "из"=>0.00109744944619449,
     "ком"=>0.00109744944619449,
     "ент"=>0.001077126308302,
     "ци"=>0.00105680317040951,
     "стран"=>0.00105680317040951,
     "тся"=>0.00103648003251702,
     "восм"=>0.00103648003251702,
     "гол"=>0.00103648003251702,
     "пар"=>0.00101615689462453,
    }
   if probability_acute_sec[piece].nil? then probability_acute_sec[piece] = 0 end
   if probability_acute[piece].nil? then probability_acute[piece] = 0 end
   if probability_no[piece].nil? then probability_no[piece] = 0 end
   if (probability_acute_sec[piece] + probability_acute[piece] - probability_no[piece]>0) then
    if (probability_acute_sec[piece] > probability_acute[piece]) then
     return '!'
#     return 'П'
    else
     return '!'
     #return 'У'
    end
   end
   return '-'
  end
  def print() return @translation end
end
