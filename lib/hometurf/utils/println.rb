# frozen_string_literal: true

module Println
  extend self

  NONE = Object.new

  def println(msg, value = NONE)
    if value == NONE
      puts msg
    else
      printf "%-25.25s: %s\n", msg, value
    end
  end
end
