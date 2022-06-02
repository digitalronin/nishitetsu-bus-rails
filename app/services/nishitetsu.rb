# frozen_string_literal: true

require "cgi"
require "digest"
require "fileutils"
require "json"
require "net/http"
require "nokogiri"
require "time"

require_relative "./nishitetsu/api"
require_relative "./nishitetsu/departure"
require_relative "./nishitetsu/departures_parser"

class Nishitetsu
  API_URL = "http://busnavi01.nishitetsu.ne.jp"
end
