require 'hometurf/locations'
require 'hometurf/home_file'
require 'hometurf/statuses'
require 'hometurf/status_view'

module Hometurf
  class App
    def initialize
      puts "this is app"
    end

    def update_links
    end

    def suggest_links
      puts "suggest links"
      statuses = Statuses.new(locations: Locations.new(files: Pathname("/tmp/ht-test/proj/homefiles"), home: Pathname("/tmp/ht-test/proj/home")))
      view = StatusView.new(statuses)
      view.render
    end
  end
end
