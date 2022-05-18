# frozen_string_literal: true

class Nishitetsu
  class Api
    API_URL = 'http://busnavi01.nishitetsu.ne.jp'

    def initialize
      # TODO
    end

    # Returns HTML
    def live_departures(from:, to:)
      Net::HTTP.get(URI(departures_url(from:, to:)))
    end

    def bus_stops_near_location(lat:, lon:, area:)
      Net::HTTP.get(URI(bus_stop_map_url(lat:, lon:, area:)))
    end

    # key = [bus_stop["JIGYOSHA_CD"], bus_stop["TEI_CD"]].join(",")
    # e.g. 0001,660102
    def bus_routes_for_stop(key)
      params = {
        f: 'busikisaki',
        list: key,
        ns: 1,
        tei_type: 0
      }

      url = "#{API_URL}/busroute?#{querystring(params)}"

      Net::HTTP.get(URI(url))
    end

    private

    def bus_stop_map_url(lat:, lon:, area:)
      params = { f: 'maptei', lat:, lon:, area: }
      arr = params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }
      arr += [
        CGI.escape('tei_type[]=0'),
        CGI.escape('tei_type[]=1')
      ]
      querystring = arr.join('&')
      "#{API_URL}/map?#{querystring}"
    end

    def departures_url(from:, to:)
      params = {
        f_zahyo_flg: 0, f_list: from,
        t_zahyo_flg: 0, t_list: to,
        rightnow_flg: 2,
        stime_flg: 1,
        jkn_busnavi: 1,
        syosaiFlg: 0
      }

      "#{API_URL}/route?#{querystring(params)}"
    end

    def querystring(params)
      params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
    end
  end
end
