require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/forecasters/doubles_forecaster'

describe "Brock::DoublesForecaster" do

  module DoublesForecaster
    include Brock::DoublesForecaster
  end

  describe "#project_doubles" do

    describe "for age 35" do
      let (:stats) { { 33 => { :games => 100, :hits => 100, :doubles => 15 },
                       34 => { :games => 100, :hits => 120, :doubles => 17 },
                       35 => { :games => 100, :hits => 120 } } }

      it "returns the correct value" do
        DoublesForecaster.project_doubles(35, stats).should eq(17)
      end
    end

    describe "for ages other than 35" do
      let (:stats) { { 20 => { :games => 100, :hits => 100, :doubles => 15 },
                       21 => { :games => 100, :hits => 120, :doubles => 17 },
                       22 => { :games => 100, :hits => 111 } } }

      it "returns the correct value" do
        DoublesForecaster.project_doubles(22, stats).should eq(16)
      end
    end
  end

end
