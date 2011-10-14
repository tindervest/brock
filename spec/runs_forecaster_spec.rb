require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/forecasters/runs_forecaster'


describe "Brock::RunsForecaster" do

  module RunsForecaster
    include Brock::RunsForecaster
  end

  describe "#project_runs" do

    it "returns 0 when prior year's runs created is 0" do
      stats = { 33 => { :rc => 0, :runs => 0 },
                34 => { :rc => 100, :runs => 0 } } 
      RunsForecaster.project_runs(34, stats).should eq(0)
    end 

    it "returns correct value when stats are available" do
      stats = { 33 => { :rc => 100, :runs => 87 },
                34 => { :rc => 120, :runs => 0 } } 
      RunsForecaster.project_runs(34, stats).should eq(104)
    end
  end

  describe "#project_rbi" do

    it "returns correct value when stats are available" do
      stats = { 22 => { :home_runs => 15, :total_bases => 222 } }
      RunsForecaster.project_rbi(stats[22]).should eq(67)
    end
  end
end
