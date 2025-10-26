require 'pathname'
require 'hometurf/locations'

module Hometurf
  class Processor
    attr_reader :homedir, :filesdir

    def initialize(locations)
      @homedir = Pathname.new locations.home
      @filesdir = Pathname.new locations.files
    end
  end
end
