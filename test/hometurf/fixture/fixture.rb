# frozen_string_literal: true

require 'test_helper'
require 'hometurf/fixture/test_fixture'

module Hometurf
  class FixtureSingleton < TestFixture
    include Singleton

    def initialize
      super "/tmp/ht-test-files"
    end
  end

  module WithFixture
    def fixture
      FixtureSingleton.instance
    end

    def files_instance
      executor = ActualExecutor.new
      Files.new fixture.locations, executor
    end

    def home
      fixture.home
    end

    def away
      fixture.away
    end

    def elsewhere
      fixture.elsewhere
    end

    def windows
      fixture.windows
    end

    def create_home_files * files
      create_files home, *files
    end

    def create_away_files * files
      create_files away, *files
    end

    def create_elsewhere_files * files
      create_files elsewhere, *files
    end

    def create_windows_files * files
      create_files windows, *files
    end

    def create_files where, *files
      files.each { |it| where.create_file it }
    end
  end
end