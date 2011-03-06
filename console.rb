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
#$source = Source.new("I ásked no óther thing,\nNo óther was deníed.\nI óffered Béing for it;\nThe míghty mérchant smíled.",@log) #Эмили Дикинсон
#заметьте: в слове denied ударение на второй слог, в слове offered — на первый
#$source = Source.new("I'd ráther be a spárrow than a snáil\nYés I wóuld,\nif I cóuld\nI súrely wóuld\nI ráther be a hámmer than a náil\nYés I wóuld,\nif I ónly cóuld\nI súrely wóuld.",@log) #Simon & Garfunkel
$source = Source.new("Máry had a líttle lamb,\nlíttle lamb, líttle lamb,\nMáry had a líttle lamb,\nwhóse fléece was whíte as snow.\nAnd éverywhere that Máry went,\nMáry went, Máry went,\nand éverywhere that Máry went,\nthe lámb was súre to go.",@log)
#$source = Source.new("Then upón the vélvet sínking,\nI betóok mysélf to línking\nFáncy únto fáncy, thínking\nwhat this óminous bird of yóre -\nWhat this grim, ungáinly, ghástly,\ngáunt and óminous bird of yóre\nMéant in cróaking „Nevermóre.”",@log) # The Raven
#$source = Source.new("O´nce upo´n a mi´dnight dre´ary,\nwhi´le I po´ndered we´ak and we´ary,\nO´ver ma´ny a qua´int and cu´rious\nvo´lume of forgo´tten lo´re,\nWhi´le I no´dded, ne´arly na´pping,\nsu´ddenly the´re ca´me a ta´pping,\nAs of so´me o´ne ge´ntly ra´pping,\nra´pping at my cha´mber do´or.\n`'Tis so´me vi´sitor,' I mu´ttered,\n`ta´pping at my cha´mber do´or -\nO´nly this, and no´thing mo´re.'\nAh, disti´nctly I reme´mber\nit was in the ble´ak Dece´mber,\nAnd e´ach se´parate dy´ing e´mber\nwro´ught its gho´st upo´n the flo´or.\nE´agerly I wi´shed the mo´rrow;\n- va´inly I had so´ught to bo´rrow\nFrom my bo´oks surce´ase of so´rrow\n- so´rrow for the lost Leno´re -\nFor the ra´re and ra´diant ma´iden\nwhom the a´ngels na´med Leno´re -\nNa´meless he´re for e´vermore.\nAnd the si´lken sad unce´rtain\nru´stling of e´ach pu´rple cu´rtain\nThri´lled me - fi´lled me with fanta´stic\nte´rrors ne´ver felt befo´re;\nSo that now, to still the be´ating\nof my hea´rt, I sto´od repe´ating\n`'Tis so´me vi´sitor entre´ating\ne´ntrance at my cha´mber do´or -\nSo´me la´te vi´sitor entre´ating\ne´ntrance at my cha´mber do´or; -\nThis it is, and no´thing mo´re,'",@log) # The Raven
$source.find_rhymes()
$source.replace()
result = $source.translate()
if result != false then
 $source.arrange()
 @log << $source.print()
end
