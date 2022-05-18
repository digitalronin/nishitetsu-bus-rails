# frozen_string_literal: true

class BusRoutesController < ApplicationController
  before_action :set_bus_route, only: %i[show edit update destroy]

  # GET /bus_routes or /bus_routes.json
  def index
    @bus_routes = BusRoute.all
  end

  # GET /bus_routes/1 or /bus_routes/1.json
  def show
  end

  # GET /bus_routes/new
  def new
    @bus_route = BusRoute.new
  end

  # GET /bus_routes/1/edit
  def edit
  end

  # POST /bus_routes or /bus_routes.json
  def create
    @bus_route = BusRoute.new(bus_route_params)

    respond_to do |format|
      if @bus_route.save
        format.html { redirect_to bus_route_url(@bus_route), notice: "Bus route was successfully created." }
        format.json { render :show, status: :created, location: @bus_route }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bus_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bus_routes/1 or /bus_routes/1.json
  def update
    respond_to do |format|
      if @bus_route.update(bus_route_params)
        format.html { redirect_to bus_route_url(@bus_route), notice: "Bus route was successfully updated." }
        format.json { render :show, status: :ok, location: @bus_route }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bus_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bus_routes/1 or /bus_routes/1.json
  def destroy
    @bus_route.destroy

    respond_to do |format|
      format.html { redirect_to bus_routes_url, notice: "Bus route was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bus_route
    @bus_route = BusRoute.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bus_route_params
    params.require(:bus_route).permit(:name)
  end
end
