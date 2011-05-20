require 'eventmachine'
require 'em-http'
require 'nokogiri'
require 'pony'


EMAIL_TO = "spencer@citrusme.com"


module Craiger
  # Your code goes here...

  module Cities
    
    extend self
    
    def all
      %w(santabarbara ventura slo santamaria bakersfield sandiego)
    end
    
  end


  class Search
    
    attr_reader :query
    
    def initialize(query="")
      @query = query.to_s.strip.gsub(/\s+/, " + ")
    end
    
    def day
      @day ||= Time.now.strftime('%B %d').gsub(/\s0/, ' ')
    end
    
    def results
      @results ||= []
    end
    
    def run!
      return if @query.empty?
      puts "Searching for #{@query}!"
      
      EventMachine.run {
        
        cities = Cities.all
        count = 0
        total = cities.length
        cities.each do |city|
          print 'o'
          http = EventMachine::HttpRequest.new("http://#{city}.craigslist.org/search/cta").get :query => { 'query' => @query, 'minAsk' => 10000, 'maxAsk' => 25000 }
          http.errback { p 'Uh oh'; EM.stop }
          http.callback {
            print '*'
            parse http.response
            EventMachine.stop if (count += 1) == total
          }
        end    
      }
      
      display
      email
                  
    end
    
    
    def parse(html)
      doc = Nokogiri::HTML(html)
      rows = doc.css('p.row').select{ |i| i.text =~ /#{day}/ }
      results << rows.map{|i| [i.text.to_s.gsub(/[\t\r\n]*/, "").gsub(/[\s]+/, " "), "  " + i.css('a').attr('href') ].join("\n") }
    end
    
    def display
      puts "\n\n"
      puts "RESULTS:"
      results.flatten.each do |result|
        puts "-" * 88
        puts result
      end
      
      #puts results.flatten.join("\n")
      
      puts "-" * 88
      puts "\n\n"
    end
    
    def email
      
      Pony.mail(
        :to        => EMAIL_TO,
        :from      => 'craiger@citrusme.com',
        :subject   => "Search results for #{query}",
        :body      =>  results.flatten.join("\n\n"),
        :charset   => 'utf8',
        :via       => :sendmail
      )
      
      puts "Email sent to #{EMAIL_TO}"
      
    end
    
  end
  
end
