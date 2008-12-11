#
# Ruby/ProgressBar - a text progress bar library  VERSION = "0.9"
#
# Copyright (C) 2001-2005 Satoru Takabayashi <satoru@namazu.org>
#     All rights reserved.
#     This is free software with ABSOLUTELY NO WARRANTY.
#
# You can redistribute it and/or modify it under the terms
# of Ruby's license.
#
# 
# 
#require 'rtui/progress/bar'
#require 'rtui/progress/spinner'

module Rtui
  
  #
  #  Progress indicators
  #
  class Progress
    attr_reader   :title
    attr_reader   :current
    attr_reader   :total
    attr_accessor :start_time
  
    #
    # Initializes a progress indicator.
    #
    # Examples:
    #
    # Just a bar and ETA:
    # Rtui::Progress.new("Foo", 10, { :components => [:bar, :stat]})
    #
    # A Spinner with just percentage:
    # Rtui::Progress.new("Foo", 10, { :components => [:spinner, :percentage]})
    #
    # 
    # Options:
    # - bar => "=" 
    # - out => STDERR 
    # 
    # Components:
    # - title
    # - spinner
    # - percentage
    # - stat
    # - bar
    #
    def initialize (title, total, *options)
      options = options.first || {}
      @title = title
      @total = total
      @terminal_width = 80
      @current = 0
      @previous = 0
      @finished = false
      @start_time = Time.now
      @previous_time = @start_time
      @title_width = 14

      @out        = options[:out] || STDERR
      @bar_mark   = options[:bar] || "="
      @colors     = options[:colors] || false
      @components = options[:components] || [:title, :percentage, :bar, :stat]

      clear
      show
    end

    def clear
      @out.print "\r#{(" " * (get_width - 1))}\r"
    end

    def finish
      @current = @total
      @finished = true
      show
    end

    def finished?
      @finished
    end

    def file_transfer_mode
      return unless @components.index(:stat)
      @components[@components.index(:stat)] = :stat_for_file_transfer
    end

    def format= (format)
      @format = format
    end

    def components= (arguments)
      @components = arguments
    end

    def halt
      @finished = true
      show
    end

    def inc step = 1
      @current += step
      @current = @total if @current > @total
      show_if_needed
      @previous = @current
    end

    def set (count)
      if count < 0 || count > @total
        raise "invalid count: #{count} (total: #{@total})"
      end
      @current = count
      show_if_needed
      @previous = @current
    end

    def inspect
      "#<Rtui::Progress:#{@current}/#{@total}>"
    end
  
    
    private
  
  
    def fmt_bar
      bar_width = do_percentage * @terminal_width / 100
      sprintf("|%s%s|", 
              @bar_mark * bar_width, 
              " " *  (@terminal_width - bar_width))
    end
    
    def fmt_spinner
      bar_width = do_percentage * @terminal_width / 100
      sprintf(" %s%s ", 
           do_percentage == 100 ? " " : '/-\\|'[do_percentage%4].chr ,
              " " *  (@terminal_width / 100) ) 
    end
    
    
    def fmt_percentage
      "%3d%%" % do_percentage
    end

    def fmt_stat
      @finished ? elapsed : eta
    end

    def fmt_stat_for_file_transfer
      sprintf("%s %s %s", bytes, transfer_rate, fmt_stat)
    end

    def fmt_title
      @title[0,(@title_width - 1)] + ":"
    end

    def convert_bytes (bytes)
      if bytes < 1024
        sprintf("%6dB", bytes)
      elsif bytes < 1024 * 1000 # 1000kb
        sprintf("%5.1fKB", bytes.to_f / 1024)
      elsif bytes < 1024 * 1024 * 1000  # 1000mb
        sprintf("%5.1fMB", bytes.to_f / 1024 / 1024)
      else
        sprintf("%5.1fGB", bytes.to_f / 1024 / 1024 / 1024)
      end
    end

    def transfer_rate
      bytes_per_second = @current.to_f / (Time.now - @start_time)
      sprintf("%s/s", convert_bytes(bytes_per_second))
    end

    def bytes
      convert_bytes(@current)
    end

    def format_time (t)
      t = t.to_i
      sec = t % 60
      min  = (t / 60) % 60
      hour = t / 3600
      sprintf("%02d:%02d:%02d", hour, min, sec);
    end

    # ETA stands for Estimated Time of Arrival.
    def eta
      if @current == 0
        "ETA:  --:--:--"
      else
        elapsed = Time.now - @start_time
        eta = elapsed * @total / @current - elapsed;
        sprintf("ETA:  %s", format_time(eta))
      end
    end

    def elapsed
      sprintf("Time: %s", format_time(Time.now - @start_time))
    end

    def eol
      @finished ? "\n" : "\r"
    end

    def do_percentage
      return 100 if @total.zero?
      @current  * 100 / @total
    end

    def get_width
      # FIXME: I don't know how portable it is.
      default_width = 80
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

    def show
      line = @components.map {|method| 
        send(sprintf("fmt_%s", method))
      }.join " "

      width = get_width
      if line.length == width - 1 
        @out.print(line + eol)
        @out.flush
      elsif line.length >= width
        @terminal_width = [@terminal_width - (line.length - width + 1), 0].max
        if @terminal_width == 0 then @out.print(line + eol) else show end
      else # line.length < width - 1
        @terminal_width += width - line.length + 1
        show
      end
      @previous_time = Time.now
    end

    def show_if_needed
      if @total.zero?
        cur_percentage = 100
        prev_percentage = 0
      else
        cur_percentage  = (@current  * 100 / @total).to_i
        prev_percentage = (@previous * 100 / @total).to_i
      end

      # Use "!=" instead of ">" to support negative changes
      if cur_percentage != prev_percentage || 
          Time.now - @previous_time >= 1 || @finished
        show
      end
      
    end

  end

  class ReversedProgress < Progress
    
    def do_percentage
      100 - super
    end
    
  end
  
end