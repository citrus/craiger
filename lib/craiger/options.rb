module Craiger

  class Options
    
    def self.discover!
      
      Request.new("sfbay").send do |html|
        doc = Nokogiri::HTML(html)
        links = doc.css('#sss li a')
        puts links.sort.map{|i| [i.text, i.attr('href')].join("\t") }.join("\n")
      end
      
    end
  
  end

end
