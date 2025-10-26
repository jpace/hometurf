require 'pathname'

module Hometurf
  class Locations
    attr_reader :files, :home

    PROJECT_DIR_ENVNAME = "HOMETURF_FILES_DIRECTORY"
    HOME_DIR_ENVNAME = "HOME_NOT_REALLY"

    def initialize(files: PROJECT_DIR_ENVNAME, home: HOME_DIR_ENVNAME)
      @files = Pathname.new files
      @home = Pathname.new home
    end
  end
end
