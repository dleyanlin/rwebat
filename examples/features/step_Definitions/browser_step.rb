When /^I visit the site url$/ do 
  visit($siteurl,$option)
end

Then /^I get the site url address "([^\"]*)"$/ do |address|
 url.match(address)
end

When /^I set option to "([^\"]*)"$/ do |b|
  visit($siteurl,b)
end

Then /^I should seen that ie browser$/ do 
  is_ie?.should ==true
end

When /^borwser pop up a windows and attach the title "([^\"]*)"$/ do |t|
  visit($siteurl,$option)
  mc.when_present.click
  claendar.click
  attach_to_window(:title=>t)
end

Then /^I get the windows title "([^\"]*)"$/ do |t|
  title.should == t
end

When /^have iframe in the page$/ do
  visit($siteurl,$option)
end

And /^switch the frame "([^\"]*)"$/ do |f|
  switch_to_frame(:name=>f)
  #puts html
  #joinnow.click
  #switch_to_default_content(:name=>frame)
end

Then /^the joinnow button exists$/ do
  joinnow.exists?.should == true
  joinnow.click

end