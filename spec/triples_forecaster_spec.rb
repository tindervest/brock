require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/triples_forecaster'

describe "Brock::TriplesForecaster" do

  module TriplesForecaster
    include Brock::TriplesForecaster
  end

  describe "#project_triples" do
    describe "for all ages" do
      let (:stats) { { 23 => { :games => 100, :hits => 0, :triples => 0 },
                       24 => { :games => 100, :hits => 0, :triples => 0 },
                       25 => { :games => 100, :hits => 120 } } }

      it "returns 0 when total hits for last 2 years is equal to zero" do
        TriplesForecaster.project_triples(25, stats).should eq(0)
      end
    end
    describe "for ages up to 25" do
      let (:stats) { { 23 => { :games => 100, :hits => 100, :triples => 4 },
                       24 => { :games => 100, :hits => 120, :triples => 7 },
                       25 => { :games => 100, :hits => 120 } } }

      it "returns the correct value" do
        TriplesForecaster.project_triples(25, stats).should eq(6)
      end
    end

    describe "for ages higher than 25" do
      let (:stats) { { 24 => { :games => 100, :hits => 100, :triples => 4 },
                       25 => { :games => 100, :hits => 120, :triples => 7 },
                       26 => { :games => 100, :hits => 120 } } }

      it "returns the correct value" do
        TriplesForecaster.project_triples(26, stats).should eq(5)
      end
    end
  end
end
