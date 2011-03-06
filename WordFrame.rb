#!/usr/bin/env ruby
#encoding: utf-8
class WordFrame < Frame
 def initialize(title)
  super( nil, :title => title, :size => [800, 200] )
  sizer_add_word = BoxSizer.new(Wx::HORIZONTAL)
  sizer_add_word_main = BoxSizer.new(Wx::VERTICAL)
  @new_word = Wx::TextCtrl.new(self, -1, 'Введите слово на исходном языке',Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE);
  @new_translation = Wx::TextCtrl.new(self, -1, 'Введите перевод',Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE);
  button_save_word = Wx::Button.new(self, -1, 'Сохранить перевод слова')
  button_save_word_and_close = Wx::Button.new(self, -1, 'Сохранить перевод слова и закрыть диалог')
  button_close = Wx::Button.new(self, -1, 'Закрыть диалог без сохранения изменений')
  sizer_add_word.add(@new_word, 1, Wx::GROW|Wx::ALL, 2)
  sizer_add_word.add(@new_translation, 1, Wx::GROW|Wx::ALL, 2)
  sizer_add_word_main.add(sizer_add_word, 0, Wx::GROW|Wx::ALL|Wx::ALIGN_CENTER_HORIZONTAL, 2)
  sizer_add_word_main.add(button_save_word, 0, Wx::ALL|Wx::ALIGN_CENTER_HORIZONTAL, 2)
  sizer_add_word_main.add(button_save_word_and_close, 0, Wx::ALL|Wx::ALIGN_CENTER_HORIZONTAL, 2)
  sizer_add_word_main.add(button_close, 0, Wx::ALL|Wx::ALIGN_CENTER_HORIZONTAL, 2)
  self.set_sizer(sizer_add_word_main)
  evt_button(button_save_word.get_id, :on_save)
  evt_button(button_save_word_and_close.get_id, :on_save_and_close)
  evt_button(button_close.get_id, :on_close)
 end
 def on_save
  output = File.open('dictionaries/user.txt', 'a')
  output.puts(@new_word.value)
  output.puts('  '+@new_translation.value)
  output.close
 end
 def on_save_and_close
  self.on_save()
  self.on_close()
 end
 def on_close
  self.hide()
 end
end