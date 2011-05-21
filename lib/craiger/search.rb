module Craiger

  class Search
    
    attr_reader :query, :results
    
    def initialize(query, options={})
      @query = options
      @query[:query] = query.to_s.strip.gsub(/\s+/, " + ")
    end
    
    
    def run!
      puts "Searching for #{@query}!"
      @results = []
      @cities = Locations.all #.shuffle.take(10)
      
      count = 0
      per_group = 25
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
            
            multi.responses[:failed].each do |response|
              puts "\n" * 4
              puts "response to #{response} failed"
              pp response
              puts "\n" * 4
            end
            
            @parser = Parser.new multi.responses[:succeeded].map(&:response)
            @results += @parser.results
            
            print "+ "
            print @parser.results.length
            print " = "
            puts @results.length
            
            EM.stop
                        
          }
          trap("INT") { EM.stop; break }
        }
      end
      
      display
      #email
                  
    end
  
    def display
      puts "\n\n"
      puts "RESULTS:"
      @results.each do |result|
        puts "-" * 88
        puts result
      end
      puts "-" * 88
      puts "\n\n"
    end
    
    def email
      
      Pony.mail(
        :to        => EMAIL_TO,
        :from      => 'craiger@citrusme.com',
        :subject   => "Search results for #{query}",
        :body      =>  @results.join("\n\n"),
        :charset   => 'utf8',
        :via       => :sendmail
      )
      
      puts "#{Time.now.strftime('%x %X')} - Email sent to #{EMAIL_TO}"
      
    end
    
  end
  
end