require 'nokogiri'

module Craiger

  class Parser
  
    attr_reader :html, :results
    
    def initialize(data)
      @data = data
      @results = []
      parse!
    end
    
    def day
      @day ||= Time.now.strftime('%B %d').gsub(/\s0/, ' ')
    end
    
    private
    
      def parse!
        @data = [@data] if @data.is_a? String
        raise ArgumentError unless @data.respond_to?(:map)
        @data.each do |html|
          doc = Nokogiri::HTML(html)
          rows = doc.css('p.row').select{ |i| i.text =~ /#{day}/ }
          @results << rows.map{|i| [i.text.to_s.gsub(/[\t\r\n]*/, "").gsub(/[\s]+/, " "), "  " + i.css('a').attr('href') ].join("\n") }
        end
        @results.flatten!
      end      
      
  end

end
