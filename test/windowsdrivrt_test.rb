require File.expand_path(File.dirname(__FILE__)+"/../" )+'/lib/rwebat'

#system 'C:\Program Files (x86)\WebEx\Record Playback\AtAuthor.exe'
puts parent = find_window("CPfwMainFrame")

child = enum_child_windows(parent)
puts child
puts getclassname parent
child.each {|children| puts getclassname children}
puts parent_handle child[1]
#puts getwindowtext child[0]
child.each {|children| puts getwindowtext children}