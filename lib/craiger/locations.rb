module Craiger

  module Locations
    
    extend self
     
    def all
      #%w(santabarbara ventura slo) #  santamaria bakersfield sacramento stockton redding sandiego bellingham seattle portland)      
      %w(sfbay abilene akroncanton albany albanyga albuquerque altoona amarillo ames anchorage annarbor annapolis appleton asheville ashtabula athensga athensohio atlanta auburn augusta austin bakersfield baltimore batonrouge battlecreek beaumont bellingham bemidji bend billings binghamton bham bismarck bloomington bn boise boone boston boulder bgky bozeman brainerd brownsville brunswick buffalo butte capecod catskills cedarrapids cnj cenla centralmich chambana charleston charlestonwv charlotte charlottesville chattanooga chautauqua chicago chico chillicothe cincinnati clarksville cleveland clovis collegestation cosprings columbiamo columbia columbus columbusga cookeville corpuschristi corvallis chambersburg dallas danville dayton daytona decatur nacogdoches delrio delaware denver desmoines detroit dothan dubuque duluth eastidaho eastoregon eastco newlondon eastnc eastky martinsburg easternshore eauclaire elpaso elko elmira erie eugene evansville fairbanks fargo farmington fayetteville fayar fingerlakes flagstaff flint shoals florencesc keys fortcollins fortdodge fortsmith fortwayne frederick fredericksburg fresno fortmyers gadsden gainesville galveston glensfalls goldcountry grandforks grandisland grandrapids greatfalls greenbay greensboro greenville gulfport norfolk hanford harrisburg harrisonburg hartford hattiesburg honolulu cfl helena hickory rockies hiltonhead holland houma houston hudsonvalley humboldt huntington huntsville imperial indianapolis inlandempire iowacity ithaca jxn jackson jacksontn jacksonville onslow janesville jerseyshore jonesboro joplin kalamazoo kalispell kansascity kenai kpr racine killeen kirksville klamath knoxville kokomo lacrosse lasalle lafayette tippecanoe lakecharles loz lakeland lancaster lansing laredo lascruces lasvegas lawrence lawton allentown lewiston lexington limaohio lincoln littlerock logan longisland losangeles louisville lubbock lynchburg macon madison maine ksu mankato mansfield masoncity mattoon mcallen meadville medford memphis mendocino merced meridian milwaukee minneapolis missoula mobile modesto mohave monroemi monroe montana monterey montgomery morgantown moseslake muncie muskegon myrtlebeach nashville nh newhaven neworleans blacksburg newyork lakecity nd newjersey northmiss northplatte nesd northernwi nmi wheeling nwct nwga nwks enid ocala odessa ogden okaloosa oklahomacity olympic omaha oneonta orangecounty oregoncoast orlando outerbanks owensboro palmsprings panamacity parkersburg pensacola peoria philadelphia phoenix csd pittsburgh plattsburgh poconos porthuron portland potsdam prescott provo pueblo pullman quadcities raleigh rapidcity reading redding reno providence richmond richmondin roanoke rmn rochester rockford roseburg roswell sacramento saginaw salem salina saltlakecity sanangelo sanantonio sandiego slo sanmarcos sandusky santabarbara santafe santamaria sarasota savannah scottsbluff scranton seattle sheboygan showlow shreveport sierravista siouxcity siouxfalls siskiyou skagit southbend southcoast sd miami southjersey ottumwa seks juneau semo swv carbondale smd swks marshall natchez bigbend swva swmi spacecoast spokane springfieldil springfield staugustine stcloud stgeorge stjoseph stlouis pennstate statesboro stillwater stockton susanville syracuse tallahassee tampa terrehaute texarkana texoma thumb toledo topeka treasure tricities tucson tulsa tuscaloosa tuscarawas twinfalls twintiers easttexas up utica valdosta ventura burlington victoriatx visalia waco washingtondc waterloo watertown wausau wenatchee wv quincy westky westmd westernmass westslope wichita wichitafalls williamsport wilmington winchester winstonsalem worcester wyoming yakima york youngstown yubasutter yuma zanesville)
    end
    
    def discover!
      # visits the US city page and extracts the city names
      # http://geo.craigslist.org/iso/us
      EM.run {
        http = EM::HttpRequest.new("http://geo.craigslist.org/iso/us").get
        http.errback { p 'Uh oh'; EM.stop }
        http.callback {
          print '*'
          doc = Nokogiri::HTML(http.response)
          links = doc.css('#list a').map{|i| i.attr('href').match(/\/\/([^\.]*)\.craigslist.org/)[1] }
          puts links.sort.join(" ")
          puts "\n"
          EM.stop
        }
      }
    end
    
  end
  
end
