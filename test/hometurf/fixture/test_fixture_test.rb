# frozen_string_literal: true

require 'hometurf/files'
require 'test_helper'
require 'hometurf/fixture/test_fixture'
require 'hometurf/utils/println'
require 'hometurf/exec/actual_executor'

module Hometurf
  class TestFixtureTest < Test::Unit::TestCase
    include Println

    test "init" do
      ENV["HOMETURF_FILES_DIRECTORY"] = "/tmp/hometurf"
      locations = Locations.new(files: Pathname.new("/tmp/home-test/proj/projfiles"), home: Pathname.new("/tmp/home-test"))
      obj = new_files_instance locations
      assert_equal(Pathname.new("/tmp/home-test/proj/projfiles"), obj.away.dir)
      assert_equal(Pathname.new("/tmp/home-test"), obj.home.dir)
    end

    test "status in home" do
      fixture = TestFixture.new "/tmp/ht-test-home"
      files = new_files_instance fixture.locations
      home_elements = files.home.elements

      homedir = fixture.home.directory
      elsedir = fixture.elsewhere.directory
      awaydir = fixture.away.directory

      assert_equal 7, home_elements.size

      a = get_element home_elements, homedir + ".a"
      assert_equal homedir + ".a", a.file
      assert_nil a.link

      b = get_element home_elements, homedir + ".b"
      assert_equal homedir + ".b", b.file
      assert_not_nil b.link

      c = get_element home_elements, homedir + ".c"
      assert_equal homedir + ".c", c.file
      assert_equal elsedir + ".c", c.link

      f = get_element home_elements, homedir + ".f"
      assert_equal homedir + ".f", f.file
      assert_not_nil f.link
      assert_equal awaydir + ".f", f.link

      h = get_element home_elements, homedir + ".h"
      assert_equal homedir + ".h", h.file
      assert_not_nil h.link
      assert_equal elsedir + ".h", h.link

      i = get_element home_elements, homedir + ".i"
      assert_equal homedir + ".i", i.file
      assert_nil i.link
    end

    def get_element home_elements, name
      home_elements.detect { |x| x.file == name }
    end

    def assert_no_link homefiles, name
      assert_nil homefiles.find { |x| x.link == name }
    end

    def assert_link homefiles, name
      link = homefiles.find { |x| x.link == name }
      assert link
      link
    end

    test "status in projfiles" do
      fixture = TestFixture.new "/tmp/ht-test-projfiles"
      files = new_files_instance fixture.locations
      homefiles = files.home.elements.sort_by(&:file)
      projdir = files.away.dir

      x = projdir + "common/.b"
      assert_equal fixture.away.directory + "common/.b", x
      link = assert_link homefiles, x
      assert_equal fixture.home.directory + ".b", link&.file

      x = projdir + ".d"
      assert_equal fixture.away.directory + ".d", x
      assert_no_link homefiles, x

      x = projdir + ".f"
      assert_equal fixture.away.directory + ".f", x
      assert_link homefiles, x

      x = projdir + ".git"
      assert x.directory?
      assert_equal fixture.away.directory + ".git", x
      assert_no_link homefiles, x

      x = projdir + ".idea"
      assert x.directory?
      assert_equal fixture.away.directory + ".idea", x
      assert_no_link homefiles, x

      x = projdir + ".j"
      assert x.directory?
      assert_equal fixture.away.directory + ".j", x
      assert_no_link homefiles, x

      x = projdir + "common"
      assert_equal fixture.away.directory + "common", x
      assert x.directory?

      x = projdir + "common/dot.o"
      assert_equal fixture.away.directory + "common/dot.o", x
      assert x.file?
      assert_link homefiles, x
    end

    def new_files_instance locations
      executor = ActualExecutor.new
      Files.new locations, executor
    end
  end
end
