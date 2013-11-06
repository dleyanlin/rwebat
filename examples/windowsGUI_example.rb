require "rwebat"

window = RAutomation::Window.new(:title => /part of the title/i)
window.exists? # => true

window.title # => "blah blah part Of the title blah"
window.text # => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultricies..."

window.text_field(:class => "Edit", :index => 0).set "hello, world!"
button = window.button(:value => "&Save")
button.exists? # => true
button.click

all_windows = RAutomation::Window.windows
all_windows.each {|window| puts window.hwnd}

window = RAutomation::Window.new(:title => /part of the title/i)
windows = window.windows
puts windows.size # => 2
windows.map &:title # => ["part of the title 1", "part of the title 2"]

window.windows(:title => /part of other title/i) # => all windows with matching specified title

window.buttons.each {|button| puts button.value}
window.buttons(:value => /some value/i).each {|button| puts button.value}

window2 = RAutomation::Window.new(:title => "Other Title", :adapter => :autoit) # use AutoIt adapter
# use adapter's (in this case AutoIt's) internal methods not part of the public API directly
window2.WinClose("[TITLE:Other Title]")