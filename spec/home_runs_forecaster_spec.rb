require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/home_runs_forecaster'

describe "Brock::HomeRunsForecaster" do
  module HomeRunsForecaster
    include Brock::HomeRunsForecaster
  end

  describe "#project_home_runs" do

    describe "for ages below 26" do
      let (:stats) { { 20 => { :hits => 100, :home_runs => 20 },
                       21 => { :hits => 120, :home_runs => 25 },
                       22 => { :hits => 120 } } }

      it "returns correct value" do
        HomeRunsForecaster.project_home_runs(22, stats).should eq(26)
      end
    end

    describe "for ages 26 thru 27" do
      let (:stats) { { 24 => { :hits => 100, :home_runs => 20 },
                       25 => { :hits => 120, :home_runs => 25 },
                       26 => { :hits => 120 } } }

      it "returns correct value" do
        HomeRunsForecaster.project_home_runs(26, stats).should eq(28)
      end
    end

    describe "ages 28 thru 29" do
      let (:stats) { { 26 => { :hits => 100, :home_runs => 20 },
                       27 => { :hits => 120, :home_runs => 25 },
                       28 => { :hits => 120 } } }

      it "returns correct value" do
        HomeRunsForecaster.project_home_runs(28, stats).should eq(23)
      end
    end
  end
end

