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
#$source = Source.new("Máry had a líttle lamb,\nlíttle lamb, líttle lamb,\nMáry had a líttle lamb,\nwhóse fléece was whíte as snow.\nAnd éverywhere that Máry went,\nMáry went, Máry went,\nand éverywhere that Máry went,\nthe lámb was súre to go.",@log)
#$source = Source.new("Then upón the vélvet sínking,\nI betóok mysélf to línking\nFáncy únto fáncy, thínking\nwhat this óminous bird of yóre -\nWhat this grim, ungáinly, ghástly,\ngáunt and óminous bird of yóre\nMéant in cróaking „Nevermóre.”",@log) # The Raven
#$source = Source.new("O´nce upo´n a mi´dnight dre´ary,\nwhi´le I po´ndered we´ak and we´ary,\nO´ver ma´ny a qua´int and cu´rious\nvo´lume of forgo´tten lo´re,\nWhi´le I no´dded, ne´arly na´pping,\nsu´ddenly the´re ca´me a ta´pping,\nAs of so´me o´ne ge´ntly ra´pping,\nra´pping at my cha´mber do´or.\n`'Tis so´me vi´sitor,' I mu´ttered,\n`ta´pping at my cha´mber do´or -\nO´nly this, and no´thing mo´re.'\nAh, disti´nctly I reme´mber\nit was in the ble´ak Dece´mber,\nAnd e´ach se´parate dy´ing e´mber\nwro´ught its gho´st upo´n the flo´or.\nE´agerly I wi´shed the mo´rrow;\n- va´inly I had so´ught to bo´rrow\nFrom my bo´oks surce´ase of so´rrow\n- so´rrow for the lost Leno´re -\nFor the ra´re and ra´diant ma´iden\nwhom the a´ngels na´med Leno´re -\nNa´meless he´re for e´vermore.\nAnd the si´lken sad unce´rtain\nru´stling of e´ach pu´rple cu´rtain\nThri´lled me - fi´lled me with fanta´stic\nte´rrors ne´ver felt befo´re;\nSo that now, to still the be´ating\nof my hea´rt, I sto´od repe´ating\n`'Tis so´me vi´sitor entre´ating\ne´ntrance at my cha´mber do´or -\nSo´me la´te vi´sitor entre´ating\ne´ntrance at my cha´mber do´or; -\nThis it is, and no´thing mo´re,'",@log) # The Raven
#$source = Source.new("Ten li´ttle I´njuns sta´ndin' in a li´ne,\nO´ne to´ddled ho´me and then the´re we´re ni´ne;\nNi´ne li´ttle I´njuns swi´ngin' on a ga´te,\nO´ne tu´mbled off and then the´re we´re e´ight.\nO´ne li´ttle, two li´ttle, thre´e li´ttle, fo´ur li´ttle, fi´ve li´ttle I´njun bo´ys,\nSix li´ttle, se´ven li´ttle, e´ight li´ttle, ni´ne li´ttle, ten li´ttle I´njun bo´ys.\nE´ight li´ttle I´njuns ga´yest u´nder he´av'n.\nO´ne we´nt to sle´ep and then the´re we´re se´ven;\nSe´ven li´ttle I´njuns cu´ttin' up the´ir tricks,\nO´ne bro´ke his neck and then the´re we´re six.\nSix li´ttle I´njuns all ali´ve,\nO´ne ki´cked the bu´cket and then the´re we´re fi´ve;\nFi´ve li´ttle I´njuns on a ce´llar do´or,\nO´ne tu´mbled in and then the´re we´re fo´ur.\nFo´ur li´ttle I´njuns up on a spre´e,\nO´ne got fu´ddled and then the´re we´re thre´e;\nThre´e li´ttle I´njuns o´ut on a cano´e,\nO´ne tu´mbled overbo´ard and then the´re we´re two.\nTwo li´ttle I´njuns fo´olin' with a gun,\nO´ne shot t'o´ther and then the´re was o´ne;\nO´ne li´ttle I´njun li´vin' all alo´ne,\nHe got ma´rried and then the´re we´re no´ne.",@log)
#$source = Source.new("When in disgra´ce with fo´rtune and men’s e´yes\nI all alo´ne bewe´ep my o´utcast sta´te,\nAnd tro´uble de´af he´aven wi´th my bo´otless cri´es,\nAnd lo´ok upo´n myse´lf, and cu´rse my fa´te,\nWi´shing me li´ke to o´ne mo´re rich in ho´pe,\nFe´atured li´ke him, li´ke him with frie´nds posse´ssed,\nDesi´ring this man’s art, and that man’s sco´pe,\nWith what I most enjo´y conte´nted le´ast;\nYet in the´se tho´ughts myse´lf a´lmost despi´sing,\nHaply I think on the´e,—and then my sta´te,\nLi´ke to the lark at bre´ak of day ari´sing\nFrom su´llen e´arth, sings hymns at he´aven’s ga´te;\nFor thy swe´et lo´ve reme´mbered such we´alth brings\nThat then I scorn to cha´nge my sta´te with kings.",@log)
#$source = Source.new("The´re was an Old Man of Peru´\nWho ne´ver knew what he sho´uld do;\nSo he sat on a cha´ir,\nAnd beha´ved li´ke a be´ar,\nThat unha´ppy Old Man of Peru.",@log)
#$source = Source.new("The´re was a You´ng La´dy of Bu´te,\nWho pla´yed on a si´lver-gi´lt flu´te;\nShe pla´yed se´veral jigs,\nTo her u´ncle's whi´te pigs,\nThat amu´sing You´ng La´dy of Bu´te.",@log)
#$source = Source.new("'Tis a fa´vourite pro´ject of mi´ne,\nA new va´lue of pi to assi´gn.\nI wo´uld fix it at thre´e,\nFor it's si´mpler, yo´u se´e,\nThan thre´e po´int o´ne fo´ur o´ne fi´ve ni´ne",@log)
$source = Source.new("The´re o´nce was a fly on the wall\nI wo´nder why didn't it fall\nBeca´use its fe´et stuck\nOr was it just luck\nOr do´es gra´vity miss thi´ngs so small?",@log)

$source.find_rhymes()
$source.replace()
result = $source.translate()
if result != false then
 $source.arrange()
 @log << $source.print()
end
