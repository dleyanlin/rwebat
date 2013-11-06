require File.join(File.dirname(__FILE__), 'browser')
include Rwebat::Browser

$recorder_msi_path = File.expand_path(File.dirname(__FILE__)+"/../../atrecply.msi")
$recorder_msi_path = $recorder_msi_path.gsub("/","\\")


module Rwebat
  module Recorder

    def recorder_is_installed?
      if is_windows?
    	  begin 
    	    cmd = ' reg query "HKCU\SOFTWARE\WebEx\Uninstall" /v RecordPlayback '
    	    result = `#{cmd}`
          return true unless !result.include?("Installed") 
    	  rescue => e
    	    raise "No install webex recorder in the machine #{e}"
          return false
    	  end
      end
    end

    def install_recorder
       if is_windows? && !recorder_is_installed?
      	begin
      	  #cmd = 'msiexec /i "#{$recorder_msi_path}"'
          `msiexec /q /i "#{$recorder_msi_path}" `
      	rescue Exception => e
      	  raise "get error when implement install #{e}"
      	end
      end 
    end

    def uninstall_recorder
      if is_windows? && recorder_is_installed?
      	begin
      	  #cmd = 'msiexec /x "#{$recorder_msi_path}"'
         ` msiexec /q /x "#{$recorder_msi_path}" `
      	rescue Exception => e
      	  raise "No install recordre application #{e}"
      	end
      end
    end
  end
end