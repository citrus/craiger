require 'eventmachine'
require 'em-http'
require 'nokogiri'
require 'sqlite3'
require 'sequel'
require 'pony'

require 'craiger/locations'
require 'craiger/search'
require 'craiger/parser'

EMAIL_TO = "spencer@citrusme.com"

DB = Sequel.sqlite('db/craiger.db')

module Craiger
  
end
