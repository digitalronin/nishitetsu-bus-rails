class DeparturesController < ApplicationController
  def show
    @from = BusStop.find(params[:from])
    @to = BusStop.find(params[:to])

    api = Nishitetsu::Api.new

    html = api.live_departures(
      from: @from.api_id,
      to: @to.api_id,
    )

    @dp = Nishitetsu::DeparturesParser.new(html)
  end
end
