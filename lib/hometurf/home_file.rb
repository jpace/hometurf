# frozen_string_literal: true

require 'hometurf/locations'

class HomeFile
  def initialize name
    @name = name
  end

  def project_file
    @project_file ||= begin
                        project_dir = Hometurf::Locations.new.home_files_directory
                        Pathname.new(project_dir) + @name
                      end
  end

  def home_file
    @home_file ||= begin
                     homedir = ENV["HOME"]
                     Pathname.new(homedir) + @link
                   end
  end
end
