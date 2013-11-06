require 'rexml/document'
require 'yaml'
require 'faker'

module Rwebat
  module Data

	#-------------------------------------------------------
	#   #Introduce:
	#      get test data from table of data.html file
	#  #parameter
	#    column: 
	#    row   :
	#--------------------------------------------------------
	def get_table_values(column,row)
	   
		 $myDir = File.expand_path(File.dirname(__FILE__)+"../../")
		 $myDir.sub!( %r{/cygdrive/(\w)/}, '\1:/' ) # convert from cygwin to dos
		 # if you run the unit tests form a local file system use this line
		 $htmlRoot =  "file://#{$myDir}/data/" 
		 # if you run the unit tests from a web server use this line
		 #   $htmlRoot =  "http://localhost:8080/watir/html/"
	  
		 $ie1=Watir::IE.start($htmlRoot+"data.html")
		  
		 $value="#{$ie1.table(:index,1)[column][row].text}"
		 $value=$value.to_s
		 return $value
		  
	end
	   
	#-------------------------------------------------------
	#   #Introduce:
	#      get test data from data.xml file 
	#         return the elements text value
	#  #parameter
	#    element: the element in xml file
	#    
	#------------------------------------------------------ 
	def get_xml_attribute_values(xmlfile,element,attribute)

		 #$myDir = File.expand_path(File.dirname(__FILE__)+"/../")
		 #puts $myDir
		 if xmlfile !=""
		  xml = REXML::Document.new(File.open(xmlfile))#$myDir+
		  if element !="" && attribute !=""
		   @@value=xml.elements[element].attributes[attribute]
		   return @@value
		  end  
		 end
	end
	   
	#--------------------------------------------------------
	#   #Introduce:
	#      get test data from data.xml file 
	#         return the elements text value
	#  #parameter
	#    element: the element in xml file
	#    
	#---------------------------------------------------------
	def get_xml_element(xmlfile,tablename)

	  xml = REXML::Document.new(File.open(xmlfile))
	  $xmlkeyword=Hash.new
	  $xmlvalue=Hash.new
	  $xmltype=Hash.new
	  xml.elements.each(tablename) {|element|
			if element.has_attributes?
			   $xmlkeyword["#{element.name}"]=element.attributes['keyword']
			   $xmlvalue["#{element.name}"]=element.attributes['value']
			end
			if element.has_elements?
			   $tdata=Array.new(4){Array.new()}
			   $i=0
			   element.each_element do |grandchild|
				 #$xmlkeyword["#{grandchild.name}"]=grandchild.attributes['keyword']
				 #$xmlvalue["#{grandchild.name}"]=grandchild.attributes['value']
				 #$xmltype["#{grandchild.name}"]=grandchild.attributes['type']
				 $tdata[0][$i]=grandchild.attributes['type']#$xmltype["#{grandchild.name}"]
				 $tdata[1][$i]=grandchild.attributes['keyword']#$xmlkeyword["#{grandchild.name}"]
				 $tdata[2][$i]=grandchild.attributes['value']#$xmlvalue["#{grandchild.name}"]
				 $i=$i+1
			  end
			end
		}
	end

	def add_attribute_value(xmlfile,tablename,attribute,value)
	  xml = REXML::Document.new(File.open(xmlfile))
	  subelement=xml.elements["#{tablename}"] 
	  subelement.attributes[attribute]=value
	  xmlf=File.open(xmlfile,"w")
	  xmlf.print xml
	  xmlf.close
	end

	def add_test_result(xmlfile,casenumber,result,description)
	   xml = REXML::Document.new(File.open(xmlfile))
	   time = Time.now.strftime("%m-%d-%Y-%H-%M-%S")

	   number= xml.root.elements['Testcasenumber']
	   number=number.add_element 'num',{'date'=>time}
	   number.add_text(casenumber)
	 
	   res= xml.root.elements['Testresult']
	   res=res.add_element 'result', {'date'=>time}
	   res.add_text(result)
	   
	   desc= xml.root.elements['description']
	   desc=desc.add_element 'desc', {'date'=>time}
	   desc.add_text(description)
	  
	   xmlf=File.open(xmlfile,"w")
	   xmlf.print xml
	   xmlf.close

	end
	#---------------------------------------------
	#   #Introduce:
	#     generate a random string  
	#  #parameter
	#    length: the string length
	#    
	#---------------------------------------------
	def randstring(length = 10)
	   chars = [*"a".."z"] + [*"0".."9"]+[*"A".."Z"]
	   rand_string = []
	   length.times { rand_string << chars[rand(chars.size)] }
	   rand_string.join
	end

	def write_text(topic)
	   @@myDir = File.expand_path(File.dirname(__FILE__)+"/../")
	   txtfile=File.open(@@myDir+"/data/topic.txt","w")
	   txtfile.puts topic
	   txtfile.close
	end

	def read_text
	  @@myDir = File.expand_path(File.dirname(__FILE__)+"/../")
	  txtfile=File.open(@@myDir+"/data/topic.txt","r")
	  @@topic=txtfile.readlines
	  @@topic=@@topic.to_s
	  @@topic=@@topic.split("\n")
	  txtfile.close
	  return @@topic.to_s
	end

	#---------------------------------------------------------
	#~ example for usage: i[0] is the value in the 1st column, i[1] is the value in the 2st column
	#~ for i in read_excel("zzz")
	#~ puts  i[0]
	#~ puts  i[1].to_s.to_i.to_s
	#~ end
	#---------------------------------------------------------
	def read_excel(filename)
	   @@myDir = File.expand_path(File.dirname(__FILE__)+"/../")
	   excel = WIN32OLE.new("excel.application") 
	   excel.Visible = false
	   excel.WorkBooks.Open(@@myDir+"/data/#{filename}"+".xls")
	   num=excel.WorkSheets(1).UsedRange.columns.count
	   array = Array.new(num){Array.new()}
	   array = excel.WorkSheets(1).UsedRange.value
	   excel.Quit
	   return array
		 
	end

	#-------------------read value from  yaml document--------------------------------------------------#
	def yml_directory=(directory)
       @yml_directory = directory
    end

  #
  # Returns the directory to be used when reading yml files
  #
    def yml_directory
      return @yml_directory if @yml_directory
      return default_directory if self.respond_to? :default_directory
      nil
    end
	
	def load_yml(filename)
	  @yml=YAML.load_file "#{yml_directory}/#{filename}"
	end

	def get_value_from_yml_doc(filename,paritem,subitem="")
	  load_yml(filename)
	  $parvalue = Hash.new
	  $parvalue = @yml[paritem]
	  $subvalue=$parvalue[subitem]
	  return $subvalue
	end
	
	#below:general test data example: user name, first_name, last_name and eamil address 
	#is't be generate of radom
	def full_name
	  Faker::Name.name
	end
	
	def first_name
	  Faker::Name.first_name
	end
	
	def last_name
	  Faker::Name.last_name
	end

	 def street_address
      Faker::Address.street_address
    end

    def city
      Faker::Address.city
    end

    def state
      Faker::Address.state
    end
	
	def zip_code
      Faker::Address.zip
    end

	def job_title
	  Faker::Name.title
	end
	
	def email_address
	  Faker::Internet.email
	end
	
	def company_name
	  Faker::Company.name
	end

	def phone_number
      Faker::PhoneNumber.phone_number
    end

    #
    # return random characters - default is 255 characters
    #
    def characters(character_count = 255)
      Faker::Lorem.characters(character_count)
    end

    #
    # return random words - default is 8 words
    #
    def words(number = 8)
      Faker::Lorem.words(number).join(' ')
    end

    #
    # return a random sentence - default minimum word count is 5
    #
    def sentence(min_word_count = 5)
      Faker::Lorem.sentence(min_word_count)
    end

    #
    # return random sentences - default is 5 sentences
    #
    def sentences(sentence_count = 5)
      Faker::Lorem.sentences(sentence_count).join(' ')
    end

  end 
end