module Craiger

  class Search
    
    attr_reader :query
    
    def initialize(query, options={})
      @query = options
      @query[:query] = query.to_s.strip.gsub(/\s+/, " + ")
    end
        
    def results
      @results ||= []
    end
    
    def run!
      puts "Searching for #{@query}!"
      
      @cities = Locations.all
      @count = 0
      @total = @cities.length
      
      EM.run {
        multi = EM::MultiRequest.new
      
        @cities.each do |city|
          multi.add EM::HttpRequest.new("http://#{city}.craigslist.org/search/cta").get(:query => @query)
        end
  
        #multi.add(EM::HttpRequest.new('http://www.yahoo.com/').get)
      
        multi.callback  {
          @parser = Parser.new multi.responses[:succeeded].map(&:response)
          multi.responses[:failed].each do |response|
            puts "response to #{response.location} failed"
          end
      
          EM.stop
        }
      }
      
      
      
      
      
      
      
      #EM.run {
      #  
      #  cities = Locations.all
      #  count = 0
      #  total = cities.length
      #  cities.each do |city|
      #    print 'o'
      #    http = EM::HttpRequest.new("http://#{city}.craigslist.org/search/cta").get :query => { 'query' => @query, 'minAsk' => 10000, 'maxAsk' => 25000 }
      #    http.errback { p 'Uh oh'; EM.stop }
      #    http.callback {
      #      print '*'
      #      parse http.response
      #      EM.stop if (count += 1) == total
      #    }
      #  end
      #}
      
      display
      #email
                  
    end
  
    def display
      puts "\n\n"
      puts "RESULTS:"
      @parser.results.flatten.each do |result|
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
      
      puts "#{Time.now.strftime('%x %X')} - Email sent to #{EMAIL_TO}"
      
    end
    
  end
  
end