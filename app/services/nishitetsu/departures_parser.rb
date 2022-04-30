# Parse the HTML from the nishitetsu busnavi live departures search page
# e.g.  http://busnavi01.nishitetsu.ne.jp/route?f_zahyo_flg=0&f_list=0001%2C660102&t_zahyo_flg=0&t_list=0000%2CL00001&rightnow_flg=2&sdate=2022%2F04%2F24&stime_h=12&stime_m=50&stime_flg=1&jkn_busnavi=1&syosaiFlg=0
class Nishitetsu
  class DeparturesParser
    attr_reader :doc

    def initialize(html)
      @doc = Nokogiri::HTML(html)
    end

    def departures
      doc.css("div.cassette")
        .map { |node| Departure.new(node) }
        .sort { |a,b| a.expected_in <=> b.expected_in }
    end

    def journey_start
      doc.css("form input#fkeyword").first.attributes["value"].text
    end

    def journey_end
      doc.css("form input#tkeyword").first.attributes["value"].text
    end
  end
end
