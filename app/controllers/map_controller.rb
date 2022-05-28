# frozen_string_literal: true

class MapController < ApplicationController
  def show
    @latitude = 33.6615143
    @longitude = 130.4384094
    set_search_and_clear_buttons

    render :show
  end

  def update_journey
    @from = BusStop.find(params[:from_bus_stop]) unless params[:from_bus_stop].empty?
    @to = BusStop.find(params[:to_bus_stop]) unless params[:to_bus_stop].empty?
    set_search_and_clear_buttons

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("controls", partial: "map/controls", locals: {from: @from, to: @to})
        ]
      end
    end
  end

  def update
    bus_stops = if params[:from_bus_stop].to_s == ""
      # Get all bus stop that fit inside the current map box
      BusStop.within_box(
        min_lat: params[:minLat], min_lon: params[:minLon],
        max_lat: params[:maxLat], max_lon: params[:maxLon]
      )
    else
      connected_stops_within_box(BusStop.find(params[:from_bus_stop]), params)
    end

    render json: {busStops: bus_stops}
  end

  private

  def set_search_and_clear_buttons
    if @from.nil? || @to.nil? || @from == @to
      @search_disabled = "disabled"
    else
      @search_url = departures_url(@from, @to)
    end

    if @from.nil? && @to.nil?
      @clear_disabled = "disabled"
    end
  end

  # Only return bus stops that are inside the map box if they're directly
  # connected to the "from" bus stop
  def connected_stops_within_box(bus_stop, params)
    bus_stop
      .connected_stops
      .filter { |bs| bs.latitude <= params[:maxLat] }
      .filter { |bs| bs.longitude <= params[:maxLon] }
      .filter { |bs| bs.latitude >= params[:minLat] }
      .filter { |bs| bs.longitude >= params[:minLon] }
  end
end
