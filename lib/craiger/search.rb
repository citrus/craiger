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
      
      @cities = Locations.all #.shuffle.take(10)
      
      count = 0
      per_group = 7
      total  = @cities.length
        
        
      until @cities.empty? do
      
        EM.run {
        
          multi = EM::MultiRequest.new
          
          @cities.slice!(0, per_group).each do |city|
            print "-"
            url = "http://#{city}.craigslist.org/search/cta"
            multi.add EM::HttpRequest.new(url).get(:query => @query)
          end
          
          multi.callback {
            puts "+"            
            multi.responses[:failed].each do |response|
              puts "\n" * 4
              puts "response to #{response} failed"
              pp response
              puts "\n" * 4
            end
            @parser = Parser.new multi.responses[:succeeded].map(&:response)
            
            results << @parser.results
            
            EM.stop            
          }
        }
        trap("INT") { EM.stop }
      end
       
      display
      #email
                  
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
      
      puts "#{Time.now.strftime('%x %X')} - Email sent to #{EMAIL_TO}"
      
    end
    
  end
  
end