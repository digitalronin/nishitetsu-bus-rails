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

    # render "_journey", status: :ok, locals: { from: @from, to: @to }
  end

  def update
    bus_stops = BusStop.within_box(
      min_lat: params[:minLat],
      min_lon: params[:minLon],
      max_lat: params[:maxLat],
      max_lon: params[:maxLon],
    )

    render json: { busStops: bus_stops }
  end
end