require 'Win32API'
require 'timeout'
require File.join(File.dirname(__FILE__), 'logging')
include Rwebat::Logging

module Rwebat

 module WindowsGui

   class FindTimeout < Timeout::Error; end

   def user32(name, param_types, return_value) #(1)
     Win32API.new 'user32', name, param_types, return_value
   end
  
   KEYEVENTF_KEYDOWN = 0 
   KEYEVENTF_KEYUP = 2 
  
   WM_SYSCOMMAND = 0x0112 
   SC_CLOSE = 0xF060
  
   MOUSEEVENTF_LEFTDOWN = 0x0002 
   MOUSEEVENTF_LEFTUP = 0x0004
  
   WM_CLICK = 0x00F5
   IDC_BUTTON1 = 1000
  
   SW_SHOW = 1
   WINDIALOG = "#32770"

# Find the specified window handle(give class name or title of windows)
   def find_window(class_name=nil,title = nil,timeout=30)
      findwindowAPI = user32 'FindWindow', ['P', 'P'], 'L'
      begin
        Timeout::timeout(timeout,FindTimeout) {
          sleep 0.2 while((@main_window = findwindowAPI.call class_name, nil) or (@main_window = \
            findwindowAPI.call nil, title) )<= 0 
        return @main_window }
      rescue FindTimeout
        logger.error "find windows with call name timeout"
        nil 
      end
   end

#list all children's windows handle from desktop or give parent's handle
   def enum_child_windows(hwnd = 0,timeout=30)
      child_after = 0
      @childwins = []
      findwindowexAPI = user32 'FindWindowEx',['L', 'L', 'P', 'P'],'L' 
      begin
        Timeout::timeout(timeout,FindTimeout) {
          while (child_after = (findwindowexAPI.call(hwnd, child_after, nil, nil) ) ) > 0 do
            @childwins << child_after
          end
          return @childwins}
      rescue FindTimeout
        logger.error "enum windows with timeout"
        nil
      end
   end

   def getclassname(hwnd, timeout=30)
     @buf="\0" * 255
     getClassNameAPI = user32 'GetClassName',['L', 'P', 'I'],'I' 
     begin
       Timeout::timeout(timeout,FindTimeout) { 
        sleep 0.2 while (classname = getClassNameAPI.call(hwnd, @buf, @buf.length)) <= 0 }
        return @buf.strip unless @buf.strip.empty?
     rescue FindTimeout
        logger.error "find class name of windows timeout"
        nil
     end
   end

   def parent_handle(hwnd,timeout=30)
     getparentAPI = user32 'GetParent',['L'],'L' 
     begin
       Timeout::timeout(timeout,FindTimeout) {
        sleep 0.2 while (parent = getparentAPI.call hwnd) <= 0
        return parent
        }
     rescue FindTimeout
       logger.error "find parent haldlw of windows timeout"
       nil 
     end
   end

   def setfocus(hawnd)
     setfocusAPI = user32 'SetFocus',['L'],'L'
     setfocusAPI.call hawnd 
   end

   def get_active
      getforegroundwindowAPI = user32 'GetForegroundWindow', [],'L'
      activehwmd = getforegroundwindowAPI.call 
      #puts @pophwmd
	  return activehwmd
   end
  
   def win_active(hwnd)
     showeindowAPI = user32 'ShowWindow', ['L','I'],'L'
	   showeindowAPI.call hwnd, SW_SHOW 
   end

   def type_intext(message)
      keybdeventAPI = user32 'keybd_event', ['I', 'I', 'L', 'L'], 'V'
      message.upcase.each_byte do |b| 
         keybdeventAPI.call b, 0, KEYEVENTF_KEYDOWN, 0 
         sleep 0.05 
         keybdeventAPI.call b, 0, KEYEVENTF_KEYUP, 0 
         sleep 0.05 
      end 
   end
  
   def close_window(hwnd,timeout=30)
     begin
       Timeout::timeout(timeout,FindTimeout) do 
          postmessageAPI = user32 'PostMessage', ['L', 'L', 'L', 'L'], 'L'
    	    postmessageAPI.call hwnd, WM_SYSCOMMAND, SC_CLOSE, 0 
       end
     rescue FindTimeout
       logger.error "find windows of be closed timeout"
       nil
     end
   end
  
   def get_dlg(parhwnd,id)#dlghwnd:par
      getdlgitemAPI = user32 'GetDlgItem', ['L', 'L'], 'L' 
      dlghwnd = getdlgitemAPI.call parhwnd, id.to_i
     return dlghwnd	
   end
  
   def getwindowtext(hwnd,timeout=30)
      buf="\0" * 1024
      getwindowtextAPI = user32 'GetWindowText', ['L', 'P','I'], 'I'
      begin
        Timeout::timeout(timeout,FindTimeout) {
          sleep 0.2 while (getwindowtextAPI.call(hwnd,buf,buf.length)) <= 0}
        return buf.strip unless buf.strip.empty?
      rescue FindTimeout
        logger.error "Get window text content timeout"
        nil
      end
   end
   
   def click_dlg_button(dlghwnd)
     getwindowrectAPI = user32 'GetWindowRect', ['L', 'P'], 'I' 
     rectangle = [0, 0, 0, 0].pack 'L*'
     getwindowrectAPI.call dlghwnd, rectangle 
    left, top, right, bottom = rectangle.unpack 'L*'
	
     setcursorposAPI = user32 'SetCursorPos', ['L', 'L'], 'I' 
	
     mouseeventAPI = user32 'mouse_event', ['L', 'L', 'L', 'L', 'L'], 'V' 
     center = [(left + right) / 2, (top + bottom) / 2]
     setcursorposAPI.call *center 

     mouseeventAPI.call MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0 
     mouseeventAPI.call MOUSEEVENTF_LEFTUP, 0, 0, 0, 0 
   end
  
   def sendmessage(hwmd)
     sendmessageAPI = user32 'SendMessage',['L', 'L', 'L', 'L'], 'L'
	   sendmessageAPI.call hwmd, WM_CLICK, IDC_BUTTON1,0
   end
   
   def winsystem(command)
       pid  =  Win32API.new("crtdll", "system", ['P'], 'L').Call(command)
   end
   
  end #end windowdriver
  
end