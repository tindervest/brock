require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/stats_calculator'
require 'brock/validator'
require 'brock/error'


describe "Brock::StatsCalculator" do

  module Calculator
    include Brock::StatsCalculator
    include Brock::Validator
  end
  
  # Kirby Puckett 1987 Stats
  let(:valid_stats) { { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7 } }

  let(:invalid_stats) { { :at_bats => 200, :games => 150, :doubles => 20, :triples => 1, :home_runs => 20, :walks => 10, :stolen_bases => 1, :caught_stealing => 2, :gidp => 5} }

  let(:zero_stats) { { :games => 0, :at_bats => 0, :runs => 0, :hits => 0, :doubles => 0, :triples => 0, :home_runs => 0, :rbi => 0, :stolen_bases => 0, :caught_stealing => 0, :walks => 0, :strikeouts => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :int_walks => 0 } }

  let(:minimal_stats) { { :games => 1, :at_bats => 1, :runs => 0, :hits => 0, :doubles => 0, :triples => 0, :home_runs => 0, :rbi => 0, :stolen_bases => 0, :caught_stealing => 0, :walks => 0, :strikeouts => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :int_walks => 0 } }

  describe "#total_bases" do

    it "calculates total bases" do
      Calculator.total_bases(valid_stats).should eq(333)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda{ Calculator.total_bases(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hits")
    end
  end

  describe '#extra_base_hits' do
    it "returns zero when there are no doubles, triples or home runs" do
      Calculator.extra_base_hits(zero_stats).should eq(0)
    end 

    it "returns the sum of doubles, triples and home runs" do
      Calculator.extra_base_hits(valid_stats).should eq(65)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda{ Calculator.extra_base_hits(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hits")
    end
  end

  describe "#runs_created" do
    it "returns zero when c component is zero" do
      Calculator.runs_created(zero_stats).should eq(0)
    end

    it "calculates runs created using 2002 version" do
      Calculator.runs_created(valid_stats).should eq(112.7)
    end

    it "returns zero when calculated value is negative" do
      Calculator.runs_created(minimal_stats).should eq(0)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda{ Calculator.runs_created(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hits")
    end
  end

  describe "#runs_created_25" do
    it "returns zero when outs component is zero" do
      Calculator.runs_created_25(zero_stats).should eq(0)
    end

    it "calculates value based on runs created per out rate" do
      Calculator.runs_created_25(valid_stats).should eq(6.32)
    end
  end

  describe "#batting average" do
    it "returns zero when there are no at-bats" do
      Calculator.batting_average(zero_stats).should eq(0)
    end

    it "calculates value based on hits/at-bats formula" do
      Calculator.batting_average(valid_stats).should eq(0.332)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda{ Calculator.batting_average(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hits")
    end
  end

  describe "#on_base_percentage" do
    it "returns zero when there are no plate appearances" do
      Calculator.on_base_percentage(zero_stats).should eq(0)
    end

    it "calculates value based on obp formula" do
      Calculator.on_base_percentage(valid_stats).should eq(0.367)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda { Calculator.on_base_percentage(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hbp")
    end
  end

  describe "#slugging_percentage" do
    it "returns zero when there are no at at bats" do
      Calculator.slugging_percentage(zero_stats).should eq(0)
    end

    it "returns value of total bases divided by at bats" do
      Calculator.slugging_percentage(valid_stats).should eq(0.534)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda { Calculator.on_base_percentage(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hbp")
    end
  end

  describe "#ops" do
    it "returns zero when there are no plate appearances" do
      Calculator.ops(zero_stats).should eq(0)
    end

    it "returns sum of slugging_percentage and on_base_percentage" do
      Calculator.ops(valid_stats).should eq(0.901)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda { Calculator.ops(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hbp")
    end
  end

  describe "#secondary average" do
    it "returns zero when there are no at bats" do
      Calculator.secondary_average(zero_stats).should eq(0)
    end

    it "returns value from applying Bill James' formula" do
      Calculator.secondary_average(valid_stats).should eq(0.261)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda { Calculator.secondary_average(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for hits")
    end
  end
  
end
