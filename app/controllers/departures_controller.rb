class DeparturesController < ApplicationController
  def show
    @from = BusStop.find(params[:from])
    @to = BusStop.find(params[:to])
  end
end
