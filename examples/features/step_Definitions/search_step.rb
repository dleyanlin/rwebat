#require 'rwebta'
#require File.expand_path(File.dirname(__FILE__)+"/../../../")+'/lib/rwebta'
require File.expand_path(File.dirname(__FILE__)+"/../")+'/pages/googlesearch'
#require File.join(File.dirname(__FILE__), 'pages/googlesearch')
include GoogleSearch


Given 'i am on the Google search page' do
  visit("http://www.google.com",$option)
end

When /i enter "(.*)" into input field/ do |query|
  input.when_present.set query
end

And 'i click search button in the search page' do
  search.when_present.click
end

Then /i should see link is "(.*)" in search result/ do |link_text|
  #text.should =~ /#{txt}/m
  assert_link_present_with_text(link_text)
end