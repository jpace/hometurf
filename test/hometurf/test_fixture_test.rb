# frozen_string_literal: true

require 'hometurf/files'
require_relative '../test_helper'
require_relative '../hometurf/test_fixture'
require_relative '../../lib/hometurf/utils/println'

module Hometurf
  class TestFixtureTest < Test::Unit::TestCase
    include Println

    test "init" do
      ENV["HOMETURF_FILES_DIRECTORY"] = "/tmp/hometurf"
      locations = Locations.new(files: Pathname.new("/tmp/home-test/proj/projfiles"), home: Pathname.new("/tmp/home-test"))
      obj = Files.new locations
      assert_equal(Pathname.new("/tmp/home-test/proj/projfiles"), obj.project.dir)
      assert_equal(Pathname.new("/tmp/home-test"), obj.home.dir)
    end

    test "status in home" do
      fixture = TestFixture.new
      locations = fixture.locations

      files = Hometurf::Files.new(locations)
      homefiles = files.home.elements.sort_by(&:file)

      a = homefiles[0]
      assert_equal fixture.home_dir + ".a-not-linked", a.file
      assert_nil a.link

      b = homefiles[1]
      assert_equal fixture.home_dir + ".b-linked", b.file
      assert_not_nil b.link

      c = homefiles[2]
      assert_equal fixture.home_dir + ".c-linked", c.file
      assert_equal fixture.elsewhere_dir + ".c-linked", c.link

      f = homefiles[3]
      assert_equal fixture.home_dir + ".f-linked", f.file
      assert_not_nil f.link
      assert_equal fixture.project_dir + ".f-linked", f.link

      h = homefiles[4]
      assert_equal fixture.home_dir + ".h", h.file
      assert_not_nil h.link
      assert_equal fixture.elsewhere_dir + ".h", h.link

      i = homefiles[5]
      assert_equal fixture.home_dir + ".i", i.file
      assert_nil i.link
    end

    test "status in projfiles" do
      fixture = TestFixture.new
      locations = fixture.locations
      files = Hometurf::Files.new locations
      projfiles = files.project.elements.sort
      homefiles = files.home.elements.sort_by(&:file)

      b = projfiles[0]
      assert_equal fixture.project_dir + ".b-linked", b
      bh = homefiles.find { |x| x.link == b }
      assert_not_nil bh
      assert_equal fixture.home_dir + ".b-linked", bh&.file

      d = projfiles[1]
      assert d.file?
      assert_equal fixture.project_dir + ".d-not-linked", d
      dh = homefiles.find { |x| x.link == d }
      assert_nil dh

      f = projfiles[2]
      assert_equal fixture.project_dir + ".f-linked", f
      fh = homefiles.find { |x| x.link == f }
      assert_not_nil fh

      j = projfiles[3]
      assert j.directory?
      assert_equal fixture.project_dir + ".j-not-linked", j
      jh = homefiles.find { |x| x.link == j }
      assert_nil jh

      e = projfiles[4]
      assert_equal fixture.project_dir + "dot.e-not-linked", e
      assert e.file?
      eh = homefiles.find { |x| x.link == e }
      assert_nil eh
    end
  end
end
