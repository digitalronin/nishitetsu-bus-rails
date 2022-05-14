class MapController < ApplicationController
  def show
    @latitude = 33.6615143
    @longitude = 130.4384094
    render :show
  end

  def update_journey
    if !params[:from_bus_stop].empty?
      @from = BusStop.find(params[:from_bus_stop])
    end

    if !params[:to_bus_stop].empty?
      @to = BusStop.find(params[:to_bus_stop])
    end

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.update(
            "journey",
            partial: "map/journey",
            locals: { from: @from, to: @to }
          )
        ]
      }
    end
  end

  def update
    if (params[:from_bus_stop].to_s != "")
      # Only return bus stops that are inside the map box if they're directly
      # connected to the "from" bus stop
      bus_stops = BusStop
        .find(params[:from_bus_stop])
        .connected_stops
        .filter {|bs| bs.latitude <= params[:maxLat]}
        .filter {|bs| bs.longitude <= params[:maxLon]}
        .filter {|bs| bs.latitude >= params[:minLat]}
        .filter {|bs| bs.longitude >= params[:minLon]}
    else
      # Get all bus stop that fit inside the current map box
      bus_stops = BusStop.within_box(
        min_lat: params[:minLat],
        min_lon: params[:minLon],
        max_lat: params[:maxLat],
        max_lon: params[:maxLon],
      )
    end

    render json: { busStops: bus_stops }
  end
end
