# frozen_string_literal: true

require 'hometurf/files'
require_relative '../test_helper'
require_relative '../hometurf/test_fixture'
require_relative '../utils/println'

module Hometurf
  class FilesTest < Test::Unit::TestCase
    include Println

    class << self
      def startup
        puts "startup"
        @@fixture = TestFixture.new
        @@fixture.create_test_environment
      end

      def shutdown
        puts "shutdown"
      end
    end

    def fixture
      @@fixture
    end

    test "add, link does not exist" do
      k_file = fixture.create_project_file ".k"
      locations = Hometurf::Locations.new(files: fixture.project_dir, home: fixture.home_dir)
      files = Files.new locations
      files.add_link k_file
      k_link = fixture.home_dir + ".k"
      assert k_link.exist?
      assert_equal k_file, k_link.realpath
    end

    test "add, link exists" do
      fixture.add_home_link_to_project_file ".l"
      projfile = fixture.project_dir + ".l"
      locations = Hometurf::Locations.new(files: fixture.project_dir, home: fixture.home_dir)
      files = Files.new locations
      files.add_link projfile
      link = fixture.home_dir + ".l"
      assert link.exist?
      assert_equal projfile, link.realpath
    end

    test "convert home to project" do
      fixture.add_home_file ".m"
      locations = Hometurf::Locations.new(files: fixture.project_dir, home: fixture.home_dir)
      homefile = locations.home + ".m"
      files = Files.new locations
      files.move_and_link homefile
      link = locations.home + ".m"
      puts "link: #{link}"
      assert link.exist?
      projfile = locations.files + ".m"
      assert_equal projfile, link.realpath
    end

    test "convert home to project, already exists" do
      fixture.add_home_file ".m"
      fixture.create_project_file ".m"
      locations = Hometurf::Locations.new(files: fixture.project_dir, home: fixture.home_dir)
      file = locations.home + ".m"
      files = Files.new locations
      projfile = files.filesdir + file.basename
      assert_raise(RuntimeError) { files.copy_to_project file, projfile }
    end
  end
end
