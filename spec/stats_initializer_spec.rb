require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/stats_initializer'
require 'brock/validator'


describe "Brock::StatsInitializer" do
  class Initializer
    include Brock::Validator
    extend Brock::StatsInitializer
  end

  describe "#initialize_stats" do
    it "sets :projection value to false" do
      stats = Initializer.initialize_stats[:yearly_stats]
      (20..41).each do |age|
        stats[age][:projection].should_not be_nil
        stats[age][:projection].should be_false
      end
    end
  end

end
