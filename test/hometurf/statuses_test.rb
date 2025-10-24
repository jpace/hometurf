# frozen_string_literal: true

require_relative '../test_helper'
require 'hometurf/statuses'
require_relative '../hometurf/test_fixture'
require_relative '../utils/println'

module Hometurf
  class StatusesTest < Test::Unit::TestCase
    include Println

    test "init" do
      ENV["HOMETURF_FILES_DIRECTORY"] = "/tmp/hometurf"
      locations = Hometurf::Locations.new(files: Pathname.new("/tmp/home-test/proj/projfiles"), home: Pathname.new("/tmp/home-test"))
      obj = Hometurf::Statuses.new locations: locations
      assert_equal(Pathname.new("/tmp/home-test/proj/projfiles"), obj.filesdir)
      assert_equal(Pathname.new("/tmp/home-test"), obj.homedir)
      obj.home_files
    end

    def create_dir(dir, name)
      (dir + name).tap do |pn|
        pn.mkpath unless pn.exist?
      end
    end

    def create_file(dir, name, content = name.sub(%r{^\.}, ''))
      (dir + name).tap do |pn|
        unless pn.exist?
          pn.write("#{content}\n")
        end
      end
    end

    def create_link(from, to)
      unless from.exist?
        from.make_symlink to
      end
    end

    def create_file_and_link(filedir, homedir, name)
      file = create_file filedir, name
      link = homedir + name
      create_link link, file
    end

    def show_status_short(statuses, status)
      width = 40
      rhs = if status.link
              formatted = format_file(status.link)
              if statuses.linked_to_homefiles? status
                "&> #{formatted}"
              else
                "!> #{formatted}"
              end
            else
              "?>"
            end
      width = width - 4
      lhs = format "%-#{width}.#{width}s (%1s)", status.homefile, file_type_string(status.homefile)
      printf "%s %s\n", lhs, rhs
    end

    def file_type_string(file)
      if file.file?
        "."
      elsif file.directory?
        "/"
      elsif file.symlink?
        "+"
      end
    end

    def format_file(file)
      type = if file.file?
               "."
             elsif file.directory?
               "/"
             elsif file.symlink?
               "+"
             end
      "#{file} (#{type})"
    end

    def show_projfile_status_short(projfile)
      print_line "", format_file(projfile)
    end

    def print_line lhs, rhs
      width = 40
      printf "%-#{width}.#{width}s -> %s\n", lhs, rhs
    end

    test "status in home" do
      fixture = TestFixture.new
      fixture.create_test_environment

      obj = Hometurf::Statuses.new(locations: Hometurf::Locations.new(files: fixture.home_files_dir, home: fixture.home_dir))
      homefiles = obj.home_files.sort_by(&:homefile)

      a = homefiles[0]
      assert_equal fixture.home_dir + ".a-not-linked", a.homefile
      assert_nil a.link

      b = homefiles[1]
      assert_equal fixture.home_dir + ".b-linked", b.homefile
      assert_not_nil b.link

      c = homefiles[2]
      assert_equal fixture.home_dir + ".c-linked", c.homefile
      assert_equal fixture.elsewhere_dir + ".c-linked", c.link

      f = homefiles[3]
      assert_equal fixture.home_dir + ".f-linked", f.homefile
      assert_not_nil f.link
      assert_equal fixture.home_files_dir + ".f-linked", f.link

      h = homefiles[4]
      assert_equal fixture.home_dir + ".h", h.homefile
      assert_not_nil h.link
      assert_equal fixture.elsewhere_dir + ".h", h.link

      i = homefiles[5]
      assert_equal fixture.home_dir + ".i", i.homefile
      assert_nil i.link
    end

    test "status in projfiles" do
      fixture = TestFixture.new
      fixture.create_test_environment

      obj = Hometurf::Statuses.new(locations: Hometurf::Locations.new(files: fixture.home_files_dir, home: fixture.home_dir))
      projfiles = obj.project_files.sort
      homefiles = obj.home_files.sort_by(&:homefile)

      b = projfiles[0]
      assert_equal fixture.home_files_dir + ".b-linked", b
      bh = homefiles.find { |x| x.link == b }
      assert_not_nil bh
      assert_equal fixture.home_dir + ".b-linked", bh&.homefile

      d = projfiles[1]
      assert d.file?
      assert_equal fixture.home_files_dir + ".d-not-linked", d
      dh = homefiles.find { |x| x.link == d }
      assert_nil dh

      f = projfiles[2]
      assert_equal fixture.home_files_dir + ".f-linked", f
      fh = homefiles.find { |x| x.link == f }
      assert_nil dh

      j = projfiles[3]
      assert j.directory?
      assert_equal fixture.home_files_dir + ".j-not-linked", j
      jh = homefiles.find { |x| x.link == j }
      assert_nil jh

      e = projfiles[4]
      assert_equal fixture.home_files_dir + "dot.e-not-linked", e
      assert e.file?
      eh = homefiles.find { |x| x.link == e }
      assert_nil eh
    end
  end
end
