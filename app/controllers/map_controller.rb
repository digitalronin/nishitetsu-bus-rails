# frozen_string_literal: true

class MapController < ApplicationController
  def show
    @latitude = 33.6615143
    @longitude = 130.4384094
    @view_type = params[:view_type]
    @bus_route = params[:bus_route].to_s.strip.upcase
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
    render json: {busStops: bus_stops_to_display(params)}
  end

  private

  def bus_stops_to_display(params)
    if params[:bus_route].to_s != ""
      br = BusRoute.find_by_name(params[:bus_route].strip.upcase)
      Rails.logger.info("found bus route #{params[:bus_route]}: #{br.inspect}")
      bus_stops = br.nil? ? [] : br.bus_stops
      only_within_box(bus_stops, params)
    elsif params[:from_bus_stop].to_s == ""
      bus_stops_within_box(params)
    else
      connected_stops_within_box(BusStop.find(params[:from_bus_stop]), params)
    end
  end

  def bus_stops_within_box(params)
    BusStop.within_box(
      min_lat: params[:minLat], min_lon: params[:minLon],
      max_lat: params[:maxLat], max_lon: params[:maxLon]
    )
  end

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
    only_within_box(bus_stop.connected_stops, params)
  end

  def only_within_box(list, params)
    list
      .filter { |bs| bs.latitude <= params[:maxLat] }
      .filter { |bs| bs.longitude <= params[:maxLon] }
      .filter { |bs| bs.latitude >= params[:minLat] }
      .filter { |bs| bs.longitude >= params[:minLon] }
  end
end
