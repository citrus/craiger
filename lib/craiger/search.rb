module Craiger

  class Search
    
    attr_reader :query, :results
    
    # A hash of deafult search options
    def defaults
      {
        :subsection => "cta",
        :srchType => "A"
      }
    end
    
    
    def initialize(query, options={})
      @query = defaults.merge(options)
      @query[:query] = query.to_s.strip.gsub(/\s+/, " + ")
    end
    
    
    def run!
      puts "Searching for #{@query}!"
      @results = []
      @cities = Locations.all.shuffle.take(20)
      
      
      pbar = ProgressBar.new("Searching...", @cities.length)
      Request.new(@cities).send("/search/cta", @query) do |html|
      
        puts html
      
        @parser = Parser.new html
        @results += @parser.results
        
        puts @parser.results
        
        pbar.inc
      end
      pbar.finish
      
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