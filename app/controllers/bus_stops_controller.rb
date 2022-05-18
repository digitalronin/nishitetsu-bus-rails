# frozen_string_literal: true

class BusStopsController < ApplicationController
  before_action :set_bus_stop, only: %i[show edit update destroy]

  # GET /bus_stops or /bus_stops.json
  def index
    @bus_stops = BusStop.all
  end

  # GET /bus_stops/1 or /bus_stops/1.json
  def show
  end

  # GET /bus_stops/new
  def new
    @bus_stop = BusStop.new
  end

  # GET /bus_stops/1/edit
  def edit
  end

  # POST /bus_stops or /bus_stops.json
  def create
    @bus_stop = BusStop.new(bus_stop_params)

    respond_to do |format|
      if @bus_stop.save
        format.html { redirect_to bus_stop_url(@bus_stop), notice: "Bus stop was successfully created." }
        format.json { render :show, status: :created, location: @bus_stop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bus_stop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bus_stops/1 or /bus_stops/1.json
  def update
    respond_to do |format|
      if @bus_stop.update(bus_stop_params)
        format.html { redirect_to bus_stop_url(@bus_stop), notice: "Bus stop was successfully updated." }
        format.json { render :show, status: :ok, location: @bus_stop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bus_stop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bus_stops/1 or /bus_stops/1.json
  def destroy
    @bus_stop.destroy

    respond_to do |format|
      format.html { redirect_to bus_stops_url, notice: "Bus stop was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bus_stop
    @bus_stop = BusStop.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bus_stop_params
    params.require(:bus_stop).permit(
      :upd_date, :jigyosha_name, :tei_kana, :ud_type,
      :city_name, :tei_cd, :jigyosha_cd, :tei_name,
      :tei_name_foreign, :tei_type, :city_cd, :area_type,
      :latitude, :longitude, :noriba_cd, :community_type,
      :navi_type
    )
  end
end
