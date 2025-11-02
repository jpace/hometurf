# frozen_string_literal: true

require 'hometurf/files'
require 'hometurf/utils/println'
require_relative '../test_helper'
require_relative '../hometurf/test_fixture'

module Hometurf
  class FixtureSingleton < TestFixture
    include Singleton
  end

  class FilesTest < Test::Unit::TestCase
    include Println

    def fixture
      FixtureSingleton.instance
    end

    test "add, link does not exist" do
      k_file = fixture.project.create_file ".k"
      locations = fixture.locations
      files = Files.new locations
      files.add_link k_file
      k_link = fixture.home.directory + ".k"
      assert k_link.exist?
      assert_equal k_file, k_link.realpath
    end

    test "add, link exists" do
      ell = fixture.project.create_file ".l"
      fixture.home.create_link ell
      projfile = fixture.project.directory + ".l"
      locations = fixture.locations
      files = Files.new locations
      assert_raise(RuntimeError) { files.add_link projfile }
    end

    test "convert home to project" do
      fixture.home.create_file ".m"
      locations = fixture.locations
      homefile = locations.home + ".m"
      files = Files.new locations
      files.move_and_link homefile
      link = locations.home + ".m"
      assert link.exist?
      projfile = locations.files + ".m"
      assert_equal projfile, link.realpath
    end

    test "convert home to project, already exists" do
      fixture.home.create_file ".n"
      fixture.project.create_file ".n"
      locations = fixture.locations
      file = locations.home + ".n"
      files = Files.new locations
      projfile = files.project.element file.basename
      assert_raise(RuntimeError) { files.copy_to_project file, projfile }
    end

    test "add link, home file exists, project file exists" do
      fixture.home.create_file ".p"
      fixture.project.create_file ".p"
      projfile = fixture.project.directory + ".p"
      locations = fixture.locations
      files = Files.new locations
      assert_raise(RuntimeError) { files.add_link projfile }
    end
  end
end
