module Hometurf
  module ColorString
    extend self

    def with_foreground string, color
      sprintf "\e[38;5;#{color}m%s\e[0m", string
    end

    def with_background string, color
      sprintf "\e[48;5;#{color}m%s\e[0m", string
    end
  end
end
