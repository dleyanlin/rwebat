#*****************************************
#Copyright (c) 2011
#
#*****************************************

require 'rubygems'
require 'watir-webdriver'
require File.join(File.dirname(__FILE__), 'windowsdriver')
include Rwebat::WindowsGui

module Rwebat
  module Browser
   
    #deal with open browser
    def new_ie(remote_s=nil)
      if remote_s !=nil
        $browser = Watir::Browser.new(:remote, :url => remote_s, :desired_capabilities => :ie)
      else
        $browser = Watir::Browser.new :ie
      end
      #$browser.goto(url)
      #$browser.maximize
      #wait_for_browser
    end
    private :new_ie

    def new_firefox(remote_s=nil)
      if remote_s !=nil
        $browser = Watir::Browser.new(:remote, :url => remote_s, :desired_capabilities => :firefox)
      else
        $browser = Watir::Browser.new :firefox
      end
      #$browser.goto(url)
      #$browser.maximize
      #wait_for_browser
    end
    private :new_firefox
	
	  def new_chrome(remote_s=nil)
      if remote_s !=nil
        $browser = Watir::Browser.new(:remote, :url => remote_s, :desired_capabilities => :chrome)
      else
        $browser = Watir::Browser.new :chrome
      end
      #$browser.goto(url)
      #$browser.maximize
      #wait_for_browser
    end
    private :new_chrome

    def new_browser(option='ie',remote_s=nil)
      case option
        when "ie"
          new_ie(remote_s)
        when "firefox"
          new_firefox(remote_s) 
        when "chrome"
          new_chrome(remote_s)
      end 
    end
    private :new_browser
   
    #remote serve IP params: "remote_s" example http://10.224.203.96:4444/wd/hub
    def visit(url, option='ie',remote_s=nil)
        new_browser(option,remote_s)
        goto_url(url)
        wait_for_browser
    end
	  alias open_browser visit
    #-----end deal with open browser

    def is_webdriver?
      begin
        $browser.class == Watir::Browser
      rescue 
        return false
      end
    end
    
    #check browser whether is ie in windows OS
    def is_ie?
      begin
        find_window("IEFrame")#iewindowclassname
        return true if @main_window >0
      rescue =>e
        raise "not exit ie #{e} only support on windows OS"
        return false
      end
    end
    
    #check browser whether is firefox in windows OS
    def is_firefox?
      begin
        find_window("MozillaWindowClass")#MozillaUIWindowClassname
        return true if @main_window >0
      rescue =>e
        raise "not exit firefox #{e} only support on windows OS"
        return false
      end
    end
    
    def is_chrome?
      begin
        find_window("Chrome_WidgetWin_0")#ChromeWindowClassname
        return true if @main_window >0
      rescue =>e
        raise "not exit chrome #{e} only support on windows OS"
        return false
      end
    end
    
    #close the open browser
    def close
      $browser.close
    end
    alias close_browser close
    #close all exit ie browsers
    def close_all_ies
      loop do
        if is_ie?
          close_window(@main_window)
        else
          break
        end
      end
    end
    #private :close_all_ie
    
    #close all exist firefox browsers
    def close_all_firefoxs
      loop do
        if is_firefox?
          close_window(@main_window)
        else
          break
        end
      end
    end
    #private :close_all_firefox
    
    #close all exist chrome browsers
    def close_all_chromes
      loop do
        if is_chrome?
          close_window(@main_window)
        else
          break
        end
      end
    end
    #private :close_all_firefox

    #close all exit ie/firefox browser
    def close_all_browsers
      if is_windows?
        close_all_ies
        close_all_firefoxs
        close_all_chromes
      else
        puts "Not windows OS,can't support'"
      end
    end

    #Example
       #attach_to_window(:title=>"Google")
    def attach_to_window(identifier, &block)
       win_id = {identifier.keys.first => /#{Regexp.escape(identifier.values.first)}/}
       $browser.window(win_id).use &block
    end
    alias attach_popup_browser attach_to_window
    
    #Example
       #switch_to_frame(:name=>"mainFrame")
    def switch_to_frame(name)
      #d = $browser.driver
      #unless frame_identifiers.nil?
      #  value = frame_identifiers.values.first
      $browser.wd.switch_to.frame name unless name.nil?
      #end          
    end

    def switch_to_default_content(frame_identifiers)
      $browser.wd.switch_to.default_content unless frame_identifiers.nil?          
    end

    def browser_exist?
       $browser.exist?
    end

    def url
      $browser.url
    end

    def goto_url(url)
      $browser.goto(url)
    end

    def title
      $browser.title
    end

    def html
      $browser.html
    end

    def text
      $browser.text
    end
    
    def wait_until(timeout = 10, message = nil, &block)
      $browser.wait_until(timeout, message, &block)
    end
		
    def wait_for_browser 
	    $browser.wait(8)
	    #end
	    #sleep 0.1
    end
=begin
    def wait_before_and_after
      wait_for_browser
      yield
     # wait_for_browser
     # sleep 0.5
    end
=end
    def is_windows?
      RUBY_PLATFORM.downcase.include?("mswin") or RUBY_PLATFORM.downcase.include?("mingw")
    end

    def is_linux?
      RUBY_PLATFORM.downcase.include?("linux")
    end

    def is_mac?
      RUBY_PLATFORM.downcase.include?("darwin")
    end


    def check_ie_version
      if is_windows? && @ie_version.nil?
        begin
          cmd = 'reg query "HKLM\SOFTWARE\Microsoft\Internet Explorer" /v Version';
          result = `#{cmd}`
          version_line = nil
          result.each do |line|
            if (line =~ /Version\s+REG_SZ\s+([\d\.]+)/)
              version_line = $1
            end
          end

          if version_line =~ /^\s*(\d+)\./
            @ie_version = $1.to_i
          end
        rescue => e
        end
      end
    end
    
    def execute_script(script)
      $browser.wd.execute_script(script)
    end
    
    def refresh
      $browser.refresh
    end
    
    def back
      $browser.back
    end
    
    def forward
      $browser.forward
    end
    
    def clear_cookies
      $browser.cookies.clear
    end
    
    def save_screenshot(file_name)
      $browser.screenshot.save(file_name)
    end
	
=begin	
	def support_utf8
      if is_windows_os?
        require 'win32ole'
        WIN32OLE.codepage = WIN32OLE::CP_UTF8
      end
    end
=end  
  end # end of Browser
  
end #end of Rwebta