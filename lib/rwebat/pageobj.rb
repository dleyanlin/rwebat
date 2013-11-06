require File.join(File.dirname(__FILE__), 'browser')
include Rwebat::Browser

module Rwebat
  module PageObj
    
    def browser
      @browser ||= $browser #Rwebat::Browser.new_browser
    end
    
    def page
      @page ||= browser
	    #return @page
    end
    
    def access_to(name, *args, &block)
      define_method(name) do |*args|
	       sleep(0.2)
         page.instance_exec(*args, &block)
      end
    end
  end
end#page