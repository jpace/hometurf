# frozen_string_literal: true

require 'hometurf/files'
require 'test_helper'
require 'hometurf/fixture/test_fixture'
require 'hometurf/utils/println'

module Hometurf
  class TestFixtureTest < Test::Unit::TestCase
    include Println

    test "init" do
      ENV["HOMETURF_FILES_DIRECTORY"] = "/tmp/hometurf"
      locations = Locations.new(files: Pathname.new("/tmp/home-test/proj/projfiles"), home: Pathname.new("/tmp/home-test"))
      obj = Files.new locations
      assert_equal(Pathname.new("/tmp/home-test/proj/projfiles"), obj.away.dir)
      assert_equal(Pathname.new("/tmp/home-test"), obj.home.dir)
    end

    test "status in home" do
      fixture = TestFixture.new "/tmp/ht-test-home"
      locations = fixture.locations

      files = Hometurf::Files.new(locations)
      homefiles = files.home.elements.sort_by(&:file)

      a = homefiles[0]
      assert_equal fixture.home.directory + ".a", a.file
      assert_nil a.link

      b = homefiles[1]
      assert_equal fixture.home.directory + ".b", b.file
      assert_not_nil b.link

      c = homefiles[2]
      assert_equal fixture.home.directory + ".c", c.file
      assert_equal fixture.elsewhere.directory + ".c", c.link

      f = homefiles[3]
      assert_equal fixture.home.directory + ".f", f.file
      assert_not_nil f.link
      assert_equal fixture.away.directory + ".f", f.link

      h = homefiles[4]
      assert_equal fixture.home.directory + ".h", h.file
      assert_not_nil h.link
      assert_equal fixture.elsewhere.directory + ".h", h.link

      i = homefiles[5]
      assert_equal fixture.home.directory + ".i", i.file
      assert_nil i.link
    end

    test "status in projfiles" do
      fixture = TestFixture.new "/tmp/ht-test-projfiles"
      locations = fixture.locations
      files = Hometurf::Files.new locations
      projfiles = files.away.elements.sort
      homefiles = files.home.elements.sort_by(&:file)

      index = 0

      b = projfiles[index]
      assert_equal fixture.away.directory + ".b", b
      bh = homefiles.find { |x| x.link == b }
      assert bh
      assert_equal fixture.home.directory + ".b", bh&.file
      index += 1

      d = projfiles[index]
      assert d.file?
      assert_equal fixture.away.directory + ".d", d
      assert_nil homefiles.find { |x| x.link == d }
      index += 1

      f = projfiles[index]
      assert_equal fixture.away.directory + ".f", f
      assert homefiles.find { |x| x.link == f }
      index += 1

      git = projfiles[index]
      assert git.directory?
      assert_equal fixture.away.directory + ".git", git
      assert_nil homefiles.find { |x| x.link == git }
      index += 1

      idea = projfiles[index]
      assert idea.directory?
      assert_equal fixture.away.directory + ".idea", idea
      assert_nil homefiles.find { |x| x.link == idea }
      index += 1

      j = projfiles[index]
      assert j.directory?
      assert_equal fixture.away.directory + ".j", j
      assert_nil homefiles.find { |x| x.link == j }
      index += 1

      e = projfiles[index]
      assert_equal fixture.away.directory + "dot.e", e
      assert e.file?
      assert_nil homefiles.find { |x| x.link == e }
    end
  end
end
