require File.expand_path(File.dirname(__FILE__)+"/../../../")+'/lib/rwebat'

include Rwebat

module GoogleSearch
  access_to(:input) { text_field(:name,"q")}
  access_to(:search) { button(:name,"btnK")}
  access_to(:imfeelinglucky) { button(:name,"btnI")  }
end