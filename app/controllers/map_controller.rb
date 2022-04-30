class MapController < ApplicationController
  def show
    Rails.logger.info("show")
    Rails.logger.info(params)
    @latitude = 33.6615143
    @longitude = 130.4384094
    render :show
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
