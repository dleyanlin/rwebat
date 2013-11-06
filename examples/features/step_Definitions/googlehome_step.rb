#require 'rwebta'
require File.expand_path(File.dirname(__FILE__)+"/../../../")+'/lib/rwebat'


Before do
 $option = "ie" #firefox ie
end

Given 'I am on the Google search page' do
  open_browser("http://www.google.com/ncr",$option)
end

Then /I can assert the button name is "(.*)"/ do |name|
  #text.should =~ /#{txt}/m
  #assert_button_present_with_name(name)
end

at_exit do
  close
end