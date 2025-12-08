require 'hometurf/home_file'
require 'hometurf/location'

module Hometurf
  class AwayFiles < Location
    IGNORED = %w( .git .idea synced )

    def ignore_file
      @ignore_file ||= IgnoreFile.new IGNORED
    end

    def elements
      @elements ||= dir.children
    end

    def common
      common_dir = dir + "common"
      common_dir.children.select { |it| it.basename.to_s.start_with?('.') }
    end
  end
end
