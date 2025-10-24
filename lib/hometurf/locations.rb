module Hometurf
  class Locations
    attr_reader :files, :home

    def initialize(files: ENV["HOMETURF_FILES_DIRECTORY"], home: ENV["HOME"])
      @files = Pathname.new files
      @home = Pathname.new home
    end

    def foobar arg
      puts "arg: #{arg}"
    end
  end
end
