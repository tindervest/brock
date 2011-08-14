require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/stats_calculator'

describe "Brock::StatsCalculator" do
  describe "#total_bases" do
    let(:stats) { { :year => 2000, :hits => 150, :doubles => 20, :triples => 1, :home_runs => 20} }

    it "calculates total bases" do
      Brock::StatsCalculator.total_bases(stats).should eq(232)
    end
  end
end
