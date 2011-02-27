#!/usr/bin/env ruby
#encoding: utf-8
begin
 require "wx"
rescue LoadError
 require "rubygems"
 require "wx"
end
$:.unshift File.dirname(__FILE__)
require "source.rb"
include Wx
$rlyDEBUG = false
 class MainFrame < Frame
   def initialize(title)
     super( nil, :title => title, :size => [400, 300] )
     menu = Wx::MenuBar.new
     file = Wx::Menu.new
     file.append( Wx::ID_OPEN, "&Открыть\tAlt-O", "Открыть файл источника" )
     file.append( Wx::ID_SAVE, "&Сохранить\tAlt-O", "Сохранить файл перевода" )
     file.append( Wx::ID_CLOSE, "&Закрыть\tAlt-C", "Закрыть файлы" )
     menu.append( file, "&Файл" )
     program = Wx::Menu.new
     program.append( Wx::ID_EXIT, "В&ыход\tAlt-X", "Выход" )
     program.append( Wx::ID_ABOUT, "&О программе...\tF1", "Показать информацию о программе" )
     menu.append( program, "&Программа" )
     self.menu_bar = menu
     evt_menu( Wx::ID_EXIT, :on_quit )
     evt_menu( Wx::ID_ABOUT, :on_about )
     evt_menu( Wx::ID_OPEN, :on_open )
     evt_menu( Wx::ID_SAVE, :on_save )
     evt_menu( Wx::ID_CLOSE, :on_close )
     button_start = Wx::Button.new(self, -1, 'Начать перевод')
     @button_pause = Wx::Button.new(self, -1, 'Приостановить перевод')
     #StaticText.new(self,300,"Hello World")
     @original = Wx::TextCtrl.new(self, -1, 'Здесь быть оригиналу',Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE,Wx::TE_MULTILINE);
     @translation = Wx::TextCtrl.new(self, -1, 'Здесь быть переводу',Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE,Wx::TE_MULTILINE);
     @log = Wx::TextCtrl.new(self, -1, 'Здесь будет лог',Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE,Wx::TE_MULTILINE);
     sizer_textctrls = BoxSizer.new(Wx::HORIZONTAL)
     sizer_textctrls.add(@original, 1, Wx::GROW|Wx::ALL, 2)
     sizer_textctrls.add(@translation, 1, Wx::GROW|Wx::ALL, 2)
     sizer_buttons = BoxSizer.new(Wx::HORIZONTAL)
     sizer_buttons.add(button_start, 0, Wx::ALL|Wx::ALIGN_CENTER_HORIZONTAL, 2)
     #sizer_buttons.add(@button_pause, 0, Wx::ALL|Wx::ALIGN_CENTER_HORIZONTAL, 2) #не работает, значит, не показываем
     sizer = BoxSizer.new(Wx::VERTICAL)
     sizer.add(sizer_textctrls, 1, Wx::GROW|Wx::ALL, 2)
     sizer.add(sizer_buttons, 0, Wx::ALL|Wx::ALIGN_CENTER_HORIZONTAL, 2)
     sizer.add(@log, 0, Wx::GROW|Wx::ALL, 2)
     self.set_sizer(sizer)
     evt_button(button_start.get_id, :on_start)
     evt_button(@button_pause.get_id, :on_pause)
     if ($rlyDEBUG) then on_start() end
     @opendialog = Wx::FileDialog.new(nil,"Открыть файл")
     @savedialog = Wx::FileDialog.new(nil,"Открыть файл",:style => Wx::FD_SAVE | Wx::FD_OVERWRITE_PROMPT)
   end
   def on_quit
     close
   end
   def on_start
    @original.clear();
    #@original<<"Dankon pro la mondkreintoj\nkiuj per heroestimo\ndonos al ni pliegigon\nlaux verkitaj plimensiloj.";
    @original<<"I ásked no óther thing,\nNo óther was deníed.\nI óffered Béing for it;\nThe míghty mérchant smíled.";
    $source = Source.new(@original.value,@log)
    @log.clear();
    $source.replace()
    $source.translate()
    $source.arrange()
    @translation.clear()
    @translation << $source.print()
   end
   def on_pause
    if Program.paused == false
      Program.paused = true
      @log << "\nПеревод приостановлен."
      @button_pause.set_label('Продолжить перевод')
    else
      Program.paused = false
      @log << "\nПеревод возобновлён."
      @button_pause.set_label('Приостановить перевод')
    end
   end
   def on_about
     Wx::about_box(
       :name => self.title,
       :version => "1.1",
       :description => "Автор - Александр Яковлев a.k.a. Oreolek"
     )
   end
   def on_open
     if @opendialog.show_modal == Wx::ID_OK
      @original.load_file(@opendialog.filename)
      @log << "\nОткрыт файл: #{@opendialog.filename}"
     end
   end
   def on_close
     @original.clear()
     @translation.clear()
     Program.paused = false
     @log << "\nФайл закрыт."
   end
   def on_save
     if @savedialog.show_modal == Wx::ID_OK
      @translation.save_file(@savedialog.filename)
      @log << "\nФайл перевода сохранён в #{@savedialog.filename}."
     end
   end
 end
 class Translate < App
   def on_init
     @frame = MainFrame.new("Переводчик стихов");
     if (!$rlyDEBUG) then @frame.show() end #для отладки не стоит показывать GUI, достаточно вызывать функции
   end
 end
 class Options
   attr_accessor :paused
   def initialize
     @paused = false
   end
 end
 Program = Options.new
 Translate.new.main_loop
