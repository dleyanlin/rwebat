require 'rautomation'
require 'win32/screenshot'

require File.dirname(__FILE__) + '/rwebat/pageobj'
require File.dirname(__FILE__) + '/rwebat/deletefiles'
require File.dirname(__FILE__) + '/rwebat/data'
require File.dirname(__FILE__) + '/rwebat/database'
require File.dirname(__FILE__) + '/rwebat/recorder'
require File.dirname(__FILE__) + '/rwebat/version'

include Rwebat
include Rwebat::PageObj
include Rwebat::Deletefiles
include Rwebat::Data
include Rwebat::Database
include Rwebat::Recorder

