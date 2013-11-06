
module  Rwebat

  module Deletefiles
  
   def delete_files(dir)
      Dir.foreach(dir) do |e|
        # Don't bother with . and ..
        next if [".","..","index.dat"].include? e
        fullname = dir + File::Separator + e
        if FileTest::directory?(fullname)
          delete_files(fullname)
        else
          File.delete(fullname)
        end
      end
   end

   def kill_all_tmp_files
     dir= ENV['USERPROFILE']+"\\AppData\\Local\\Microsoft\\Windows\\Temporary Internet Files"
     begin
	  delete_files(dir)
	 rescue => e
	   raise "Can't delete all files #{e}" 
	 end
   end
  
   def clear_ie_cookies
     dir = ENV['USERPROFILE']+"\\AppData\\Roaming\\Microsoft\\Windows\\Cookies"
	 delete_files(dir)
   end
   
  end
  
end

   