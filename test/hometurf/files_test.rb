# frozen_string_literal: true

require 'hometurf/files'
require 'hometurf/utils/println'
require_relative '../test_helper'
require_relative '../hometurf/test_fixture'

module Hometurf
  class FixtureSingleton < TestFixture
    include Singleton

    def initialize
      super "/tmp/ht-test-files"
    end
  end

  class FilesTest < Test::Unit::TestCase
    include Println

    def fixture
      FixtureSingleton.instance
    end

    def files_instance
      Files.new fixture.locations
    end

    def home
      fixture.home
    end

    def away
      fixture.away
    end

    test "add, link does not exist" do
      k_file = away.create_file ".k"
      files = files_instance
      files.add_link k_file
      k_link = home.file ".k"
      assert k_link.exist?
      assert_equal k_file, k_link.realpath
    end

    test "add, link exists" do
      create_away_files ".l"
      ell = away.file ".l"
      home.create_link ell
      projfile = away.file ".l"
      files = files_instance
      assert_raise(RuntimeError) { files.add_link projfile }
    end

    test "convert home to project" do
      create_home_files ".m"
      homefile = home.file ".m"
      files = files_instance
      files.move_and_link homefile
      link = home.file ".m"
      assert link.exist?
      projfile = away.file ".m"
      assert_equal projfile, link.realpath
    end

    test "convert home to project, already exists" do
      home.create_file ".n"
      away.create_file ".n"
      file = home.file ".n"
      files = files_instance
      projfile = files.away.element file.basename
      assert_raise(RuntimeError) { files.copy_to_project file, projfile }
    end

    test "add link, home file exists, project file exists" do
      create_home_files ".p"
      create_away_files ".p"
      projfile = away.file ".p"
      files = files_instance
      assert_raise(RuntimeError) { files.add_link projfile }
    end

    test "update home from project" do
      names = %w{ .r .s }
      create_away_files(*names)
      names.each { |it| assert_home_link false, it }
      files = files_instance
      files.update_home_from_project
      names.each do |it|
        assert_home_link true, it
      end
    end

    test "update single home link" do
      names = %w{ .t .u }
      create_away_files(*names)
      names.each { |it| assert_home_link false, it }
      files = files_instance
      files.update_home_from_project_file away.file ".t"
      assert_home_link true, ".t"
      assert_home_link false, ".u"
    end

    def create_home_files *files
      files.each { |it| home.create_file it }
    end

    def create_away_files *files
      files.each { |it| away.create_file it }
    end

    def assert_home_link expected, link
      assert_equal expected, (home.file link).exist?, "link: #{link}"
      assert_equal expected, (home.file link).symlink?, "link: #{link}"
      if expected
        assert_equal away.file(link), (home.file link).realpath
      end
    end

    test "update single home link, ignored" do
      files = files_instance
      files.update_home_from_project_file away.file ".idea"
      assert_home_link false, ".idea"
    end
  end
end
