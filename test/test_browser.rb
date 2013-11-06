require File.dirname(__FILE__) + '/../lib/rwebat'

visit('boeing17975.qa.webex.com',"ie")
#visit('boeingld.qa.webex.com','chrome')
if is_webdriver?
   puts "webdriver:yes"
else
   puts "webdriver:no"
end

if is_ie?
   puts "IE:yes"
else
   puts "IE:no"
end

if is_firefox?
  puts "FF:yes"
else
  puts "FF:no"
end

if is_chrome?
   puts "Chrome:yes"
else
   puts "Chrome:no"
end
puts url
puts title

#goto_url('www.cisco.com')

#save_screenshot('test.png')
close
#close_all_ies
#close_all_firefoxs