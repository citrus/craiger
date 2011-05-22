require 'progressbar'
require 'pony'
require 'pp'

require 'craiger/core_ext'
require 'craiger/request'
require 'craiger/options'
require 'craiger/locations'
require 'craiger/search'
require 'craiger/parser'



EMAIL_TO = "spencer@citrusme.com"

module Craiger
  
  def self.search(query, options)
  
    if discover = options.delete(:discover)
    
      case discover.to_sym
        when :cities, :locations
          Craiger::Locations.discover!    
        when :options, :sections
          Craiger::Options.discover!    
        else
          puts "Invalid option for discover!"
      end
      
    else
    
      Craiger::Search.new(query, options).run!
      
    end

  end
  
end
