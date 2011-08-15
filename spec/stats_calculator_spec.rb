require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/stats_calculator'

describe "Brock::StatsCalculator" do
  describe "#total_bases" do
    let(:stats) { { :year => 2000, :hits => 150, :doubles => 20, :triples => 1, :home_runs => 20} }

    it "calculates total bases" do
      Brock::StatsCalculator.total_bases(stats).should eq(232)
    end
  end

  describe "#runs_created" do
    it "returns zero when c component is zero" do
      stats = { :at_bats => 0, :walks => 0, :hbp => 0, :sh => 0, :sf => 0 }
      Brock::StatsCalculator.runs_created(stats).should eq(0)
    end

    it "calculates runs created using 2002 version" do
      # Kirby Puckett 1987 Stats
      stats = { :at_bats => 624, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7 }
      Brock::StatsCalculator.runs_created(stats).should eq(112.7)
    end
  end
end
