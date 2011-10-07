require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/forecasters/hits_forecaster'

describe "Brock::HitsForecaster" do

  module HitsForecaster
    include Brock::HitsForecaster
  end

  describe "#project_hits" do
    describe "age 22" do
      let (:stats) { { 20 => { :games => 100, :at_bats => 400, :hits => 100 },
                       21 => { :games => 100, :at_bats => 400, :hits => 120 },
                       22 => { :games => 100, :at_bats => 395 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(22, stats).should eq(115)
      end
    end

    describe "age 23" do
      let (:stats) { { 20 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       21 => { :games => 100, :at_bats => 400, :hits => 120 },
                       22 => { :games => 100, :at_bats => 395, :hits => 115 },
                       23 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(23, stats).should eq(115)
      end
    end

    describe "age 24" do
      let (:stats) { { 21 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       22 => { :games => 100, :at_bats => 400, :hits => 120 },
                       23 => { :games => 100, :at_bats => 395, :hits => 115 },
                       24 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(24, stats).should eq(116)
      end
    end

    describe "age 25" do
      let (:stats) { { 22 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       23 => { :games => 100, :at_bats => 400, :hits => 120 },
                       24 => { :games => 100, :at_bats => 395, :hits => 115 },
                       25 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(25, stats).should eq(115)
      end
    end

    describe "age 26" do
      let (:stats) { { 23 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       24 => { :games => 100, :at_bats => 400, :hits => 120 },
                       25 => { :games => 100, :at_bats => 395, :hits => 115 },
                       26 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(26, stats).should eq(113)
      end
    end

    describe "age 27" do
      let (:stats) { { 24 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       25 => { :games => 100, :at_bats => 400, :hits => 120 },
                       26 => { :games => 100, :at_bats => 395, :hits => 115 },
                       27 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(27, stats).should eq(119)
      end
    end

    describe "age 28" do
      let (:stats) { { 25 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       26 => { :games => 100, :at_bats => 400, :hits => 120 },
                       27 => { :games => 100, :at_bats => 395, :hits => 115 },
                       28 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(28, stats).should eq(108)
      end
    end

    describe "age 29" do
      let (:stats) { { 26 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       27 => { :games => 100, :at_bats => 400, :hits => 120 },
                       28 => { :games => 100, :at_bats => 395, :hits => 115 },
                       29 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(29, stats).should eq(106)
      end
    end

    describe "age 30" do
      let (:stats) { { 26 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       27 => { :games => 100, :at_bats => 400, :hits => 120 },
                       28 => { :games => 100, :at_bats => 395, :hits => 115 },
                       29 => { :games => 100, :at_bats => 400, :hits => 110 },
                       30 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(30, stats).should eq(109)
      end
    end

    describe "age 31" do
      let (:stats) { { 27 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       28 => { :games => 100, :at_bats => 400, :hits => 120 },
                       29 => { :games => 100, :at_bats => 395, :hits => 115 },
                       30 => { :games => 100, :at_bats => 400, :hits => 110 },
                       31 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(31, stats).should eq(108)
      end
    end

    describe "age 32" do
      let (:stats) { { 28 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       29 => { :games => 100, :at_bats => 400, :hits => 120 },
                       30 => { :games => 100, :at_bats => 395, :hits => 115 },
                       31 => { :games => 100, :at_bats => 400, :hits => 110 },
                       32 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(32, stats).should eq(107)
      end
    end

    describe "age 33" do
      let (:stats) { { 29 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       30 => { :games => 100, :at_bats => 400, :hits => 120 },
                       31 => { :games => 100, :at_bats => 395, :hits => 115 },
                       32 => { :games => 100, :at_bats => 400, :hits => 110 },
                       33 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(33, stats).should eq(105)
      end
    end

    describe "age 34" do
      let (:stats) { { 30 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       31 => { :games => 100, :at_bats => 400, :hits => 120 },
                       32 => { :games => 100, :at_bats => 395, :hits => 115 },
                       33 => { :games => 100, :at_bats => 400, :hits => 110 },
                       34 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(34, stats).should eq(107)
      end
    end

    describe "age 35" do
      let (:stats) { { 31 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       32 => { :games => 100, :at_bats => 400, :hits => 120 },
                       33 => { :games => 100, :at_bats => 395, :hits => 115 },
                       34 => { :games => 100, :at_bats => 400, :hits => 110 },
                       35 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(35, stats).should eq(106)
      end
    end

    describe "age 36" do
      let (:stats) { { 32 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       33 => { :games => 100, :at_bats => 400, :hits => 120 },
                       34 => { :games => 100, :at_bats => 395, :hits => 115 },
                       35 => { :games => 100, :at_bats => 400, :hits => 110 },
                       36 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(36, stats).should eq(106)
      end
    end

    describe "age 37" do
      let (:stats) { { 33 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       34 => { :games => 100, :at_bats => 400, :hits => 120 },
                       35 => { :games => 100, :at_bats => 395, :hits => 115 },
                       36 => { :games => 100, :at_bats => 400, :hits => 110 },
                       37 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(37, stats).should eq(101)
      end
    end

    describe "age 38" do
      let (:stats) { { 34 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       35 => { :games => 100, :at_bats => 400, :hits => 120 },
                       36 => { :games => 100, :at_bats => 395, :hits => 115 },
                       37 => { :games => 100, :at_bats => 400, :hits => 110 },
                       38 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(38, stats).should eq(113)
      end
    end

    describe "age 39" do
      let (:stats) { { 35 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       36 => { :games => 100, :at_bats => 400, :hits => 120 },
                       37 => { :games => 100, :at_bats => 395, :hits => 115 },
                       38 => { :games => 100, :at_bats => 400, :hits => 110 },
                       39 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(39, stats).should eq(99)
      end
    end

    describe "age 40" do
      let (:stats) { { 36 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       37 => { :games => 100, :at_bats => 400, :hits => 120 },
                       38 => { :games => 100, :at_bats => 395, :hits => 115 },
                       39 => { :games => 100, :at_bats => 400, :hits => 110 },
                       40 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(40, stats).should eq(111)
      end
    end

    describe "age 41" do
      let (:stats) { { 37 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       38 => { :games => 100, :at_bats => 400, :hits => 120 },
                       39 => { :games => 100, :at_bats => 395, :hits => 115 },
                       40 => { :games => 100, :at_bats => 400, :hits => 110 },
                       41 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        HitsForecaster.project_hits(41, stats).should eq(107)
      end
    end
  end
end
