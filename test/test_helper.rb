# frozen_string_literal: true

puts "$LOAD_PATH (1): #{$LOAD_PATH}"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "hometurf"
puts "$LOAD_PATH (2): #{$LOAD_PATH}"

require "test-unit"
