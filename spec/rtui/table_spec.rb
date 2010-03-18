require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "Progress Bar" do

  #
  # Ok. Need real tests.
  # But this REALLY works =D
  #
  describe "Visual tests" do
    it "should print" do
      RTUI::Table.new("foo", [Time, Time], :now).print
    end
  end
end


