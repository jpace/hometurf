# frozen_string_literal: true

require 'hometurf/files'
require 'hometurf/utils/println'
require 'test_helper'
require 'hometurf/fixture/fixture'

module Hometurf
  class FilesTest < Test::Unit::TestCase
    include Println
    include WithFixture

    def assert_home_link expected, link
      assert_equal expected, (home.file link).exist?, "link: #{link}"
      assert_equal expected, (home.file link).symlink?, "link: #{link}"
      if expected
        assert_equal away.file("common/#{link}"), (home.file link).realpath
      end
    end

    test "add, link does not exist" do
      k_file = away.create_file "common/.k"
      files = files_instance
      files.add_link k_file
      k_link = home.file ".k"
      assert k_link.exist?
      assert_equal k_file, k_link.realpath
    end

    test "add, link exists" do
      create_away_files "common/.l"
      ell = away.file ".l"
      home.create_link ell
      projfile = away.file "common/.l"
      files = files_instance
      assert_raise(RuntimeError) { files.add_link projfile }
      link = home.directory + ".l"
      if link.to_s.start_with? "/tmp/ht-test-files/home"
        link.unlink
      end
    end

    test "convert home to project" do
      create_home_files ".m"
      homefile = home.file ".m"
      files = files_instance
      files.move_and_link homefile
      link = home.file ".m"
      assert link.exist?
      projfile = away.file "common/.m"
      assert_equal projfile, link.realpath
    end

    test "convert home to project, already exists" do
      home.create_file ".n"
      away.create_file "common/.n"
      file = home.file ".n"
      files = files_instance
      projfile = files.away.dir + file
      assert_raise(RuntimeError) { files.copy_to_project file, projfile }
    end

    test "add link, home file exists, project file exists" do
      create_home_files ".p"
      create_away_files "common/.p"
      projfile = away.file "common/.p"
      files = files_instance
      assert_raise(RuntimeError) { files.add_link projfile }
    end

    test "update home from project" do
      names = %w{ .r .s }
      away_names = names.map { |it| "common/#{it}" }
      create_away_files(*away_names)
      names.each { |it| assert_home_link false, it }
      files = files_instance
      files.update_home_from_project
      names.each do |it|
        assert_home_link true, it
      end
    end

    test "update single home link" do
      names = %w{ .t .u }
      away_names = names.map { |it| "common/#{it}" }
      create_away_files(*away_names)
      names.each { |it| assert_home_link false, it }
      files = files_instance
      files.update_home_from_project_file away.file "common/.t"
      assert_home_link true, ".t"
      assert_home_link false, ".u"
    end

    test "update single home link, ignored" do
      files = files_instance
      files.update_home_from_project_file away.file ".idea"
      assert_home_link false, ".idea"
    end
    
    test "sync file, from more recent" do
      filename = "c/ProjectFiles/AppData/abc-xyz-config.xml"
      syncpath = "synced/tmp/ht-test-files/windows/#{filename}"
      fullpath = "/tmp/ht-test-files/windows/#{filename}"
      files = files_instance
      create_away_files syncpath
      from = away.file(syncpath)
      puts "from: #{from}"
      from.open("w") { |io| io.puts "abc" }
      dest = Pathname.new fullpath
      puts "dest: #{dest}"
      assert_false dest.exist?

      dest.parent.mkpath
      dest.open("w") { |io| io.puts "abc" }

      files.sync_file from

      assert dest.exist?
      assert_equal from.read, dest.read

      dest.open("w") { |io| io.puts "def" }
      assert_not_equal from.read, dest.read
      files.sync_file from
      assert_equal from.read, dest.read

      from.open("w") { |io| io.puts "ghi" }
      assert_not_equal from.read, dest.read
      files.sync_file from
      assert_equal from.read, dest.read
    end
  end
end
