class JourneysController < ApplicationController
  def index
    home = bus_stop "福岡女子大前"
    tenjinsan = bus_stop "天神三丁目（１５：西向き）"
    tenjinyon = bus_stop "天神四丁目"
    postoffice = bus_stop "天神中央郵便局前（１８：東向き）"

    @journeys = [
      journey(home, tenjinsan),
      journey(postoffice, home),
      journey(tenjinyon, home),
    ]
  end

  private

  def journey(from, to)
    { from: from, to: to }
  end

  def bus_stop(name)
    BusStop.find_by_tei_name(name)
  end
end
