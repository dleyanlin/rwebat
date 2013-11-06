
  # jun hirabayashi jun@hirax.net 2008.11.15-2009.04.26
  
  require 'Win32API'
  require 'win32ole'
  require 'dl/win32'
  require 'dl/import'
  
  MOUSEEVENTF_ABSOLUTE = 0x8000
  MOUSEEVENTF_MOVE = 0x1
  MOUSEEVENTF_LEFTDOWN = 0x2
  MOUSEEVENTF_LEFTUP = 0x4
  MOUSEEVENTF_RIGHTDOWN = 0x8
  MOUSEEVENTF_RIGHTUP = 0x10
  MOUSEEVENTF_MIDDLEDOWN = 0x20
  MOUSEEVENTF_MIDDLEUP = 0x40
  MOUSEEVENTF_XDOWN=0x100
  MOUSEEVENTF_XUP=0x200
  MOUSEEVENTF_WHEEL=0x80
  WM_MOUSEMOVE=0x0200
  WM_LBUTTONDOWN=0x0201
  WM_LBUTTONUP=0x0202
  WM_LBUTTONDBLCLK=0x0203
  WM_RBUTTONDOWN=0x0204
  WM_RBUTTONUP=0x0205
  WM_RBUTTONDBLCLK=0x0206
  WM_MBUTTONDOWN=0x0207
  WM_MBUTTONUP=0x0208
  WM_MBUTTONDBLCLK=0x0209
  WM_SETTEXT= 0x000C
  WM_GETTEXT= 0x000D
  WM_GETTEXTLENGTH= 0x000E
  MK_LBUTTON=0x01
  MK_RBUTTON=0x02
  MK_SHIFT=0x04 
  MK_CONTROL=0x08 
  MK_MBUTTON=0x10

  #def initialize
    @wsh=WIN32OLE.new("WScript.Shell")
    @setCursorPosAPI=Win32API.new("user32", "SetCursorPos", ['i', 'i'], 'V')
    @getCursorPosAPI=Win32API.new("user32", "GetCursorPos", ['P'], 'V')
    @mouseEventAPI=Win32API.new("user32", "mouse_event",['l', 'l','l', 'l','l'],'V')   
    @findWindowExAPI= Win32API.new("user32", "FindWindowEx", ['L','L','P', 'P'], 'L')
    @findWindowAPI=Win32API.new("user32", "FindWindow",['P', 'P'],'I')  
    @getTopWindowAPI=Win32API.new("user32", "GetTopWindow",['L'],'L')  
    @getWindowTextAPI=Win32API.new("user32", "GetWindowText",['l','P','l'],'I')
    @setForegroundWindowAPI=Win32API.new("user32", "SetForegroundWindow",['l'],'V')
    @getClassNameAPI=Win32API.new("user32", "GetClassName",['l','P','l'],'V')
    @setFocusAPI=Win32API.new("user32", "SetFocus",['l'],'V')
    @getForegroundWindowAPI=Win32API.new("user32", "GetForegroundWindow",[],'I')
    @getWindowRectAPI=Win32API.new("user32", "GetWindowRect",['I','P'],'V')
    @moveWindowAPI=Win32API.new("user32", "MoveWindow",['I','I','I','I','I','I'],'V')
    @sendMessageAPI=Win32API.new("user32", "SendMessage",['L','L','L','L'],'V')
    @postMessageAPI=Win32API.new("user32", "PostMessage",['L','L','L','L'],'V')
    @playSoundAPI=Win32API.new('winmm','PlaySound','ppl','i')
    @mciSendStringAPI=Win32API.new('winmm','mciSendString',['P'],'V')
    @user32=DL.dlopen("user32")    
    @enumWindows=@user32['EnumWindows', '0PL']
    @enumChildWindows=@user32['EnumChildWindows', '0IPL']
  #end
  
  def closeComandWindowLikeName(name,delay=2)
    findWindowLikeName(name).first.each{|w|
    setForegroundWindow(w)
    sleep delay
    sendKeys('% ',delay)   # ALT+SPACE 
    sendKeys('c',delay)    
  }

  end
  
  def run(fileOrApl)
    @wsh.Run(fileOrApl)    
  end

  def sendKeys(keys, delay=0)
    sleep delay
    @wsh.SendKeys(keys)
    # {BACKSPACE}{BS}{BKSP}
    #{BREAK}
    #{CAPSLOCK}
    #{DELETE}{DEL}
    #{DOWN}
    #{END}
    #{ENTER}
    #{ESC}
    #{HELP}
    #{HOME}
    #{INSERT}{INS}
    #{LEFT}
    #{NUMLOCK}
    #{PGDN}
    #{PGUP}
    #{PRTSC}
    #{RIGHT}
    #{SCROLLLOCK}
    #{TAB}
    #{UP}
    #{F1} ... {F12}
    #Shit =   +()  ex "+(T)his is a sanple."
    #Ctrl=    ^()
    #Alt=      %()
    #+ {+}
    #^ {^}
    #% {%}
    #{   {{}
    #}   {}}
    # {a 100} means type a 100 times    
  end

  def sendMouse(command,x=0.2,y=0.2)
    case command
      when "LEFTDOWN"
         sendLButtonDown
      when "LEFTUP"
         sendLButtonUp
      when "MIDDLEDOWN"
         sendMButtonDown
      when "MIDDLEUP"
         sendMButtonUp
      when "RIGHTDOWN"
         sendRButtonDown
      when "RIGHTUP"
         sendRButtonUp
      when "LEFTCLICK"
         sendLButtonDown
         sleep x
         sendLButtonUp       
      when "MIDDLECLICK"
         sendMButtonDown
         sleep x
         sendMButtonUp       
      when "RIGHTCLICK"
         sendRButtonDown
         sleep x
         sendRButtonUp       
      when "LEFTDOUBLECLICK"
         sendLButtonDown
         sleep x
         sendLButtonUp 
         sleep y
         sendLButtonDown
         sleep x
         sendLButtonUp 
      when "MIDDLEDOUBLECLICK"
         sendMButtonDown
         sleep x
         sendMButtonUp
         sleep y
         sendMButtonDown
         sleep x
         sendMButtonUp
      when "RIGHTDOUBLECLICK"
         sendRButtonDown
         sleep x
         sendRButtonUp
         sleep y
         sendRButtonDown
         sleep x
         sendRButtonUp
      when "ABS"
         mouseMoveAbsPix(x,y)
      when "REL"
          pos=getCursorPos
         mouseMoveAbsPix(pos[0]+x,pos[1]+y)
      when "WHEEL"
        mouseMoveWheel(w)
      else
    end
  end

  def mouseMoveAbsPix(x,y)
    @setCursorPosAPI.call(x, y)
  end

  def mouseMoveWheel(w)
    @mouseEventAPI.call(MOUSEEVENTF_WHEEL,0,0,w,0)
  end

  def findWindowLike(title)
    findWindowLikeName(title)
  end

  def findWindowLikeName(title)
    wins=[]
    @enumWindowsProc=DL.callback('IL') do |hwnd|
       buf=" "*1024
      @getWindowTextAPI.call(hwnd,buf,buf.size)
       wins << [hwnd, buf.sub(/\0.+$/,'')] if /#{title}/=~buf
       -1
     end
    @enumWindows.call(@enumWindowsProc, 0)
    DL.remove_callback(@enumWindowsProc)
    wins
  end
    
  def findChildWindowLikeName(title)
    hwnds=[]
    @enumWindowsProc=DL.callback('IL') do |hwnd|
      hwnds<< hwnd   
      -1
    end
    @enumWindows.call(@enumWindowsProc, 0)
    wins=[]
    @enumChildWindowsProc=DL.callback('IL') do |hwnd|
      buf=" "*1024
      @getWindowTextAPI.call(hwnd,buf,buf.size)
       wins << [hwnd, buf.sub(/\0.+$/,'')] if /#{title}/=~buf
       -1
     end
     hwnds.each do |hwnd|
      @enumChildWindows.call(hwnd, @enumChildWindowsProc, 0)
    end
    DL.remove_callback(@enumWindowsProc)
    DL.remove_callback(@enumChildWindowsProc)
    wins
  end

  def findWindowLikeClass(classname)
    hwnds=[]
    @enumWindowsProc=DL.callback('IL') do |hwnd|
      hwnds<< hwnd   
      -1
    end
    @enumWindows.call(@enumWindowsProc, 0)
    wins=[]
    @enumChildWindowsProc=DL.callback('IL') do |hwnd|
      buf=" "*1024
      @getClassNameAPI.call(hwnd,buf,buf.size)
       wins << [hwnd, buf.sub(/\0.+$/,'')] if /#{classname}/=~buf
       -1
     end
     hwnds.each do |hwnd|
      @enumChildWindows.call(hwnd, @enumChildWindowsProc, 0)
    end
    DL.remove_callback(@enumWindowsProc)
    DL.remove_callback(@enumChildWindowsProc)
    wins
  end

  def setForegroundWindow(hwnd)
    @setForegroundWindowAPI.call(hwnd)
  end
  
  def setFocus(hwnd)
    @setFocusAPI.call(hwnd)  
  end
  
  def getCursorPos
    lpP=" "*8
    @getCursorPosAPI.Call(lpP)
    lpP.unpack("LL")
  end
  
  def mouseEvent(event,x=0,y=0,w=0)
    @mouseEventAPI.call(event,x,y,w,0)
  end
  
  def sendLButtonUp
    mouseEvent(MOUSEEVENTF_LEFTUP)
  end

  def sendLButtonDown
    mouseEvent(MOUSEEVENTF_LEFTDOWN)
  end

  def sendMButtonUp
    mouseEvent(MOUSEEVENTF_MIDDLEUP)
  end

  def sendMButtonDown
    mouseEvent(MOUSEEVENTF_MIDDLEDOWN)
  end

  def sendRButtonUp
    mouseEvent(MOUSEEVENTF_RIGHTUP)
  end

  def sendRButtonDown
    mouseEvent(MOUSEEVENTF_RIGHTDOWN)
  end

  def sendMouseMoveRel(x,y)
    sendMouse('REL',x,y)
  end

  def sendMouseMoveAbs(x,y)
    sendMouse('ABS',x,y)
  end

  def getForegroundWindow
    @getForegroundWindowAPI.call
   end

  def getWindowRect(hwnd)
    lpP=" "*16
    @getWindowRectAPI.call(hwnd,lpP)
    lpP.unpack("LLLL")
  end
  
  def moveWindow(hwnd,x=0,y=0,width=500,height=500,repaint=1)
    @moveWindowAPI.call(hwnd,x,y,width,height,repaint)
  end

  def pushButton(button, delay=1)
    pushChildButton(getForegroundWindow, button, delay)
  end

  def pushChildButton(parent, button, delay=1)
    setForegroundWindow(parent)
    sleep delay
    hwnd=findWindowLikeName(button).first[0]
    postMessage(hwnd, WM_LBUTTONDOWN, MK_LBUTTON, 0) 
    sleep 0.5
    postMessage(hwnd, WM_LBUTTONUP, 0, 0)
  end 

  def sendMessage(hwnd,msg,wparam,lparam)
    @sendMessageAPI.call(hwnd,msg,wparam,lparam)
  end

  def postMessage(hwnd,msg,wparam,lparam)
    @postMessageAPI.call(hwnd,msg,wparam,lparam)
  end
  
  def getTopWindow(hwnd)
    @getTopWindowAPI.call(hwnd)
  end
  
  def cdAudioDoorOpen
    @mciSendStringAPI.Call('set cdaudio door open')
  end
  
  def cdAudioDoorClose
    @mciSendStringAPI.Call('set cdaudio door closed')
  end

  def playSound(file)
      @playSoundAPI.call(file,nil,0)
  end
=begin   
  def Win32GuiTest.convertPerlScript(path)
    isAlt=false
    isShift=false
    isCtrl=false
    puts "require 'win32GuiTest'"
    puts "gui=Win32GuiTest.new"
    puts ""
    puts "sleep 5"
    puts ""
    open(path)  do |f|
      f.each do |line|
        if /^#[^!]+.+$/=~line
          puts line
        else
          puts "sleep #{$1}" if /^select\(undef, undef, undef, (.+?)\);$/=~line
          puts "gui.mouseMoveAbsPix(#{$1},#{$2})"  if /^MouseMoveAbsPix\((\d.+), (\d.+)\);$/=~line
          puts "gui.sendMouse(\"#{$1}\")"  if /^SendMouse\('\{(.+?)\}'\);$/=~line
          isCtrl = true if /^SendRawKey\(VK_LCONTROL, KEYEVENTF_EXTENDEDKEY\);/=~line
          isCtrl = false if /^SendRawKey\(VK_LCONTROL, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP\);/=~line
          isAlt = true if /^SendRawKey\(VK_LMENU, KEYEVENTF_EXTENDEDKEY\);/=~line
          isAlt = false if /^SendRawKey\(VK_LMENU, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP\);/=~line
          isShift = true if /^SendRawKey\(VK_LSHIFT, KEYEVENTF_EXTENDEDKEY\);/=~line
          isShift = false if /^SendRawKey\(VK_LSHIFT, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP\);/=~line
          if /^SendKeys\('(.+?)'\);$/=~line
            texts=$1
            texts.gsub!('{BAC}','{BACKSPACE}')
            texts.gsub!('{SPC}',' ')
            texts.gsub!('{ENT}','{ENTER}')
            texts.gsub!('{LEF}','{LEFT}')
            texts.gsub!('{RIG}','{RIGHT}')
            texts.gsub!('{DOW}','{DOWN}')
            if isCtrl || isAlt || isShift
              puts "gui.sendKeys('\^\(#{texts}\)')" if isCtrl
              puts "gui.sendKeys('\%\(#{texts}\)')" if isAlt
              puts "gui.sendKeys('\+\(#{texts}\)')" if isShift
            else
              puts "gui.sendKeys('#{texts}')"
            end
          end
        end
      end
    end
  end
=begin
  
rescue Exception => e
  
end
  def Win32GuiTest.bmp2texts(file)
    # using Microsoft Office Document Imaging Library (MODI)
    doc=WIN32OLE.new('MODI.Document')
    doc.Create(file)
    doc.OCR(17, false, false) # Japanese
    img=doc.Images(0)
    layout=img.Layout
    str=layout.Text
    doc.Close
    return str
  end

  def Win32GuiTest.img2PPTbyOCR(file,texts,title='')
    powerPoint=WIN32OLE.new("PowerPoint.Application")
    powerPoint.visible=true
    ppt=powerPoint.Presentations.Open( \
      WIN32OLE.new('Scripting.FileSystemObject').GetAbsolutePathName("ocrmaster.ppt"))
    ppt.Slides(1).Shapes(1).TextFrame.TextRange.Text=title
    ppt.Slides(1).Shapes(2).TextFrame.TextRange.Text=texts
    ppt.SaveAs(WIN32OLE.new('Scripting.FileSystemObject').GetAbsolutePathName(file))
    powerPoint.Quit
  end 

  def Win32GuiTest.jpg2wmf(file,del=false)
    f=Win32GuiTest.jpg2bmp(file,false)
    f=Win32GuiTest.bmp2pbm(f)
    f=Win32GuiTest.pbm2eps(f)
    return Win32GuiTest.eps2wmf(f)
  end

  def Win32GuiTest.jpg2bmp(file,del=true)
    output=file.sub(/\.jpg$/i,'.bmp')
    command="apps\\JPG2BMP.EXE "+file+' '+output
    `#{command}`
    File.delete(file) if del
    return output
  end

def Win32GuiTest.bmp2pbm(file,del=true)
    command="apps\\mkbitmap.exe "+file
    `#{command}`
    File.delete(file) if del
    return file.sub(/\.bmp$/i,'.pbm')
  end

def Win32GuiTest.pbm2eps(file,del=true)
    command="apps\\potrace.exe "+file
    `#{command}`
    File.delete(file) if del
    return file.sub(/\.pbm$/i,'.eps')
  end
  
  def Win32GuiTest.eps2wmf(file,del=true)
    output=file.sub(/.eps$/i,'.wmf')
    command="apps\\pstoedit.exe -f emf "+file+" "+output
    `#{command}`
    File.delete(file) if del
    return file.sub(/\.eps$/i,'.wmf')
  end

def Win32GuiTest.img2PPT(file,wmf,del=true)
    powerPoint=WIN32OLE.new("PowerPoint.Application")
    powerPoint.visible=true
    ppt=powerPoint.Presentations.Open( \
      WIN32OLE.new('Scripting.FileSystemObject').GetAbsolutePathName("master.ppt"))
    ppt.Slides(1).Shapes.AddPicture(WIN32OLE.new('Scripting.FileSystemObject').GetAbsolutePathName(wmf),
      false, true,260,200,400,300)
    ppt.Slides(1).Shapes.each {|shape| 
      if shape.TextFrame.HasText != 0
        s=shape.TextFrame.TextRange.Text
        shape.TextFrame.TextRange.Text=s.sub('name',wmf.sub(/\.wmf$/i,''))
      end 
    } 
    ppt.SaveAs(WIN32OLE.new('Scripting.FileSystemObject').GetAbsolutePathName(file))
    powerPoint.Quit
    File.delete(wmf) if del
  end 
=end

findWindowLikeClass("PX_WINDOW_CLASS")