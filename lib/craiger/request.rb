require 'curb'

module Craiger

  # Craiger::Request is a simple wrapper for Curl::Easy

  class Request

    attr_reader :subdomains, :per_group
    
    def initialize(subdomains)
      @subdomains = [subdomains].flatten.compact
      @per_group = 5

      raise "No subdomains provided!" if @subdomains.empty?
    end
    
    
    def send(path="/", params={}, &block)
      c = Curl::Easy.new
      @subdomains.each do |subdomain|
        url = [
          File.join("http://#{subdomain}.craigslist.org", path),
          params.to_query_string
        ].join("?")
        c.url = url
        c.perform
        yield c.body_str
      end
    end
    
  end
  
end
