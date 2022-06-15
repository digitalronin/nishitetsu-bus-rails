# frozen_string_literal: true

class BestFitJourneysController < ApplicationController
  def index
    @latitude = 33.5969244
    @longitude = 130.4242298
  end

  def update_journey
    @from = params[:from]

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("controls", partial: "best_fit_journeys/controls", locals: {from: @from, to: @to})
        ]
      end
    end
  end
end
