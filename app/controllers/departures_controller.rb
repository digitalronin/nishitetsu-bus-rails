class DeparturesController < ApplicationController
  def show
    @from = BusStop.find(params[:from])
    @to = BusStop.find(params[:to])

    @return_url = "/departures/#{@to.id}/#{@from.id}"

    api = Nishitetsu::Api.new

    html = api.live_departures(
      from: @from.api_id,
      to: @to.api_id,
    )

    @dp = Nishitetsu::DeparturesParser.new(html)
  end
end
