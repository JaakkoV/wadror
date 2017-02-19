require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end

  end

  describe "in case of cache hit" do

    before :each do
      Rails.cache.clear
    end

    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      # ensure that data found in cache
      BeermappingApi.places_in("espoo")

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq("Rautatienkatu 24")
    end
  end

  it "returns empty array, when HTTP GET doesn't find anything" do
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*esp/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

    places = BeermappingApi.places_in("esp")

    expect(places.size).to eq(0)
  end

  it "returns many parsed entries, when HTTP GET returns many results" do
    canned_answer = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>6698</id><name>Brewbaker</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/6698</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6698&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6698&amp;d=1&amp;type=norm</blogmap><street>Flensburger Str.</street><city>Berlin</city><state></state><zip></zip><country>Germany</country><phone>3990 5156</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>12372</id><name>Eschenbraeu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12372</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12372&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12372&amp;d=1&amp;type=norm</blogmap><street>Triftstr. 67</street><city>Berlin</city><state></state><zip>13353</zip><country>Germany</country><phone>490304626837</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>12377</id><name>Brauhaus Suedstern</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12377</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12377&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12377&amp;d=1&amp;type=norm</blogmap><street>Hasenheide 69</street><city>Berlin</city><state></state><zip>10967</zip><country>Germany</country><phone>493069001624</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>12379</id><name>Brauhaus Mitte</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12379</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12379&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12379&amp;d=1&amp;type=norm</blogmap><street>Karl-Liebknecht-Str. 13</street><city>Berlin</city><state></state><zip>10178</zip><country>Germany</country><phone>493030878989</phone><overall>73.33325</overall><imagecount>4</imagecount></location><location><id>12381</id><name>Brauhaus Lemke am Schloss Charlottenburg</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12381</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12381&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12381&amp;d=1&amp;type=norm</blogmap><street>Luisenplatz 1</street><city>Berlin</city><state></state><zip>10585</zip><country>Germany</country><phone>+493030878979</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>12382</id><name>Brauhaus Lemke Hackescher Markt</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12382</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12382&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12382&amp;d=1&amp;type=norm</blogmap><street>Dircksenstr., S-Bahnbogen 143</street><city>Berlin</city><state></state><zip>10178</zip><country>Germany</country><phone>493024728727</phone><overall>86.66665</overall><imagecount>2</imagecount></location><location><id>12384</id><name>Lindenbraeu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12384</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12384&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12384&amp;d=1&amp;type=norm</blogmap><street>Bellevuestr. 3-5</street><city>Berlin</city><state></state><zip>10785</zip><country>Germany</country><phone>493025751280</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>12600</id><name>Hops and Barley</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12600</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12600&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12600&amp;d=1&amp;type=norm</blogmap><street>Wà¼hlischstr 22/23</street><city>Berlin</city><state></state><zip>10245</zip><country>Germany</country><phone>00493029367534</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>12601</id><name>Schalander Hausbrauerei</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/12601</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12601&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12601&amp;d=1&amp;type=norm</blogmap><street>Bà¤nschstr. 91</street><city>Berlin</city><state></state><zip>10247</zip><country>Germany</country><phone>+49 30 89617073</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>12813</id><name>Keg and Barrel</name><status>Homebrew</status><reviewlink>https://beermapping.com/location/12813</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12813&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12813&amp;d=1&amp;type=norm</blogmap><street>2 South Route 73</street><city>Berlin</city><state>NJ</state><zip>08009</zip><country>United States</country><phone>(856) 768-5199</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>13424</id><name>Ambrosetti</name><status>Beer Store</status><reviewlink>https://beermapping.com/location/13424</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13424&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13424&amp;d=1&amp;type=norm</blogmap><street>SchillerstraàŸe 103</street><city>Berlin</city><state></state><zip>10625</zip><country>Germany</country><phone>49 30 312 47 26</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>14388</id><name>Ollie Gators Pub</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/14388</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=14388&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=14388&amp;d=1&amp;type=norm</blogmap><street>2 Route 73</street><city>Berlin</city><state>NJ</state><zip>08009</zip><country>United States</country><phone>(856) 768-9400</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>14816</id><name>Burley Oak Brewing Company</name><status>Brewery</status><reviewlink>https://beermapping.com/location/14816</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=14816&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=14816&amp;d=1&amp;type=norm</blogmap><street>10016 Old Ocean City Blvd</street><city>Berlin</city><state>MD</state><zip>21811</zip><country>United States</country><phone>(443) 513-4647</phone><overall>92.0833625</overall><imagecount>1</imagecount></location><location><id>15426</id><name>Hopfen und Malz</name><status>Beer Store</status><reviewlink>https://beermapping.com/location/15426</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15426&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15426&amp;d=1&amp;type=norm</blogmap><street>Triftstr. 57</street><city>Berlin</city><state></state><zip>13353</zip><country>Germany</country><phone>0176 34409478</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15427</id><name>Eschenbrà¤u</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/15427</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15427&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15427&amp;d=1&amp;type=norm</blogmap><street>Triftstr. 67</street><city>Berlin</city><state></state><zip>13353</zip><country>Germany</country><phone>030/462 68 37</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15433</id><name>Klein Zaches</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/15433</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15433&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15433&amp;d=1&amp;type=norm</blogmap><street>Antwerpener Str. 43</street><city>Berlin</city><state></state><zip>13353</zip><country>Germany</country><phone>030 4535007</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15435</id><name>Zur blauen Mà¼hle</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/15435</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15435&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15435&amp;d=1&amp;type=norm</blogmap><street>Genter Str  8 </street><city>Berlin</city><state></state><zip>13353</zip><country>Germany</country><phone>(030) 4657590</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15436</id><name>Tante Elli</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/15436</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15436&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15436&amp;d=1&amp;type=norm</blogmap><street>Là¼deritzstr. 5</street><city>Berlin</city><state></state><zip>13351</zip><country>Germany</country><phone>0162-6783546</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>16560</id><name>Canal's of Berlin</name><status>Beer Store</status><reviewlink>https://beermapping.com/location/16560</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=16560&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=16560&amp;d=1&amp;type=norm</blogmap><street>8 South Route 73</street><city>Berlin</city><state>NJ</state><zip>08009</zip><country>United States</country><phone>(856) 753-1881</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18059</id><name>Brauhaus Rixdorf</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18059</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18059&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18059&amp;d=1&amp;type=norm</blogmap><street>Glasower StraàŸe 27</street><city>Berlin</city><state></state><zip>D-12051</zip><country>Germany</country><phone>030-626 88 80</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>19834</id><name>Whitehorse Brewing Company</name><status>Brewery</status><reviewlink>https://beermapping.com/location/19834</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=19834&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=19834&amp;d=1&amp;type=norm</blogmap><street>824 Diamond Street</street><city>Berlin</city><state>PA</state><zip>15530</zip><country>United States</country><phone>814-279-4994</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

    stub_request(:get, /.*berlin/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("berlin")

    expect(places.size).to eq(21)
    place = places.first
    expect(place.name).to eq("Brewbaker")
    expect(place.phone).to eq("3990 5156")
  end
end
