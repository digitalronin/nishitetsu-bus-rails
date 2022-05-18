# frozen_string_literal: true

class DeparturesController < ApplicationController
  def show
    @from = BusStop.find(params[:from])
    @to = BusStop.find(params[:to])
    @express_only = params[:express_only] == "yes"

    api = Nishitetsu::Api.new

    html = api.live_departures(
      from: @from.api_id,
      to: @to.api_id
    )

    list = Nishitetsu::DeparturesParser.new(html).departures

    @departures = @express_only ? list.filter(&:express?) : list
  end
end
