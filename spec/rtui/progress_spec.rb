require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Progress Bar" do

  #
  # Ok. Need real tests.
  # But this REALLY works =D
  #
  describe "Visual tests" do

    SleepUnit = 0.01

    def do_make_progress_bar (title, total)
      RTUI::Progress.new(title, total)
    end

    it "should pong" do
      total = 100
      pbar = RTUI::Progress.new("test(inc)", total, :bar => "o",
        :components => [:pong, :percentage])
      total.times { sleep(0.01); pbar.inc }
      pbar.finish
    end

    it "should spin!" do
      total = 100
      pbar = RTUI::Progress.new("test(inc)", total,
        :components => [:spinner, :percentage,  :stat])
      total.times { sleep(0.01); pbar.inc }
      pbar.finish
    end

    it "different bar" do
      total = 100
      pbar = RTUI::Progress.new("test(inc)", total, :bar => "_",
        :components => [  :stat, :bar, :percentage])
      total.times { sleep(SleepUnit); pbar.inc }
      pbar.finish
    end

    it "should spin 2!" do
      total = 100
      pbar = RTUI::Progress.new("test(inc)", total,
        :components => [:spinner, :percentage])
      total.times { sleep(0.01); pbar.inc }
      pbar.finish
    end

    it "should handle bytes" do
      total = 1024 * 1024
      pbar = do_make_progress_bar("test(bytes)", total)
      pbar.file_transfer_mode
      0.step(total, 2**14) {|x|
        pbar.set(x)
        sleep(SleepUnit)
      }
      pbar.finish

    end

    it "should show a subject!" do
      total = 100
      pbar = RTUI::Progress.new("test(inc)", total,
              :components => [:spinner, :percentage, :subject, :stat])
      total.times { |i| sleep(0.05); pbar.subject = "inter #{i} times!!!"; pbar.inc }
      pbar.subject = "finish it"
      pbar.finish
    end
    #
    # it "should clear" do
    #   total = 100
    #   pbar = do_make_progress_bar("test(clear)", total)
    #   total.times {
    #     sleep(SleepUnit)
    #     pbar.inc
    #   }
    #   pbar.clear
    #   puts
    #  end
  #
  #   def test_halt
  #     total = 100
  #     pbar = do_make_progress_bar("test(halt)", total)
  #     (total / 2).times {
  #       sleep(SleepUnit)
  #       pbar.inc
  #     }
  #     pbar.halt
  #   end
  #
   #  it "should test_inc" do
   #    total = 100
   #    pbar = do_make_progress_bar("test(inc)", total)
   #    total.times {
   #      sleep(SleepUnit)
   #      pbar.inc
   #    }
   #    pbar.finish
   #  end
   #
   # it "should test_inc_x" do
   #    total = File.size(File.dirname(__FILE__) + '/bar_spec.rb')
   #    pbar = do_make_progress_bar("test(inc(x))", total)
   #    File.new(File.dirname(__FILE__) + '/bar_spec.rb').each {|line|
   #      sleep(SleepUnit)
   #      pbar.inc(line.length)
   #    }
   #    pbar.finish
   #  end
  #
  #   def test_invalid_set
  #     total = 100
  #     pbar = do_make_progress_bar("test(invalid set)", total)
  #     begin
  #       pbar.set(200)
  #     rescue RuntimeError => e
  #       puts e.message
  #     end
  #   end
  #
  #   def test_set
  #     total = 1000
  #     pbar = do_make_progress_bar("test(set)", total)
  #     (1..total).find_all {|x| x % 10 == 0}.each {|x|
  #       sleep(SleepUnit)
  #       pbar.set(x)
  #     }
  #     pbar.finish
  #   end
  #
  #   def test_slow
  #     total = 100000
  #     pbar = do_make_progress_bar("test(slow)", total)
  #     0.step(500, 1) {|x|
  #       pbar.set(x)
  #       sleep(SleepUnit)
  #     }
  #     pbar.halt
  #   end
  #
  #   def test_total_zero
  #     total = 0
  #     pbar = do_make_progress_bar("test(total=0)", total)
  #     pbar.finish
  #   end
  # end
  #
  # class ReversedProgressBarTest < ProgressBarTest
  #   def do_make_progress_bar (title, total)
  #     ReversedProgressBar.new(title, total)
  #   end
  # end
  end
end
