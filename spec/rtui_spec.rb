require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe RTUI do

  it "should define RTUI" do
     RTUI::Progress.should be_a Class
  end

end
