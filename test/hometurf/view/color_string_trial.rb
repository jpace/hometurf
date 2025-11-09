# frozen_string_literal: true

dir = File.dirname(__FILE__)
project_dir = File.expand_path("../../..", dir)
lib_dir = File.join(project_dir, "lib")
$:.unshift lib_dir

require 'hometurf/utils/println'
require 'hometurf/view/color_string'

module Hometurf
  class ColorsTrial
    include Println

    def run
      (0...255).each do |i|
        println ColorString.with_foreground("color: #{i}", i)
      end
      (0...255).each do |i|
        println ColorString.with_background("color: #{i}", i)
      end
    end
  end
end

puts "hello"
obj = Hometurf::ColorsTrial.new
obj.run
