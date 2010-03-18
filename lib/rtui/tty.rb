module RTUI
  module TTY
    class << self
        def get_width
      # FIXME: I don't know how portable it is. Works Linux/OSX.
      begin
        tiocgwinsz = 0x5413
        data = [0, 0, 0, 0].pack("SSSS")
        if @out.ioctl(tiocgwinsz, data) >= 0 then
          rows, cols, xpixels, ypixels = data.unpack("SSSS")
          if cols >= 0 then cols else default_width end
        else
          default_width
        end
      rescue Exception
        default_width
      end
    end

    def default_width
      stty = `stty size`
      if stty =~ /^\d+ \d+/
        stty.split[1].to_i
      else
        80
      end
    end

    end
  end
end
