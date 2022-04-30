class MapController < ApplicationController
  def show
    @latitude = 33.6615143
    @longitude = 130.4384094
    render :show
  end

  def update_journey
    Rails.logger.info "update_journey xx#{@to}xx"
    if !params[:from_bus_stop].empty?
      from_bus_stop = BusStop.find(params[:from_bus_stop])
      @from = from_bus_stop.tei_name
    end

    if !params[:to_bus_stop].empty?
      to_bus_stop = BusStop.find(params[:to_bus_stop])
      @to = to_bus_stop.tei_name
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
