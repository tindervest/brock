require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/forecasters/plate_appearance_forecaster'

describe "Brock::PlateAppearanceForecaster" do

  module PlateAppearanceForecaster
    include Brock::PlateAppearanceForecaster
  end

  describe "#project_walks" do
    
    describe "ages 22 thru 25" do
      let (:stats) { { 20 => { :at_bats => 500, :walks => 65 },
                       21 => { :at_bats => 550, :walks => 45 },
                       22 => { :at_bats => 600 } } }

      it "returns correct value" do
        PlateAppearanceForecaster.project_walks(22, stats).should eq(67)
      end
    end

    describe "age 27" do
      let (:stats) { { 25 => { :at_bats => 500, :walks => 65 },
                       26 => { :at_bats => 550, :walks => 45 },
                       27 => { :at_bats => 600 } } }

      it "returns correct value" do
        PlateAppearanceForecaster.project_walks(27, stats).should eq(68)
      end
    end

    describe "age 28" do
      describe "when total at bats for past 2 years is greater than 100" do
        let (:stats) { { 26 => { :at_bats => 500, :walks => 65 },
                         27 => { :at_bats => 550, :walks => 45 },
                         28 => { :at_bats => 600 } } }

        it "returns correct value" do
          PlateAppearanceForecaster.project_walks(28, stats).should eq(69)
        end
      end

      describe "when total at bats for past 2 years is less than 100" do
        let (:stats) { { 26 => { :at_bats => 50, :walks => 11 },
                         27 => { :at_bats => 49, :walks => 8 },
                         28 => { :at_bats => 600 } } }

        it "returns correct value" do
          PlateAppearanceForecaster.project_walks(28, stats).should eq(87)
        end
      end
    end

    describe "age 33" do
      let (:stats) { { 31 => { :at_bats => 500, :walks => 65 },
                       32 => { :at_bats => 550, :walks => 45 },
                       33 => { :at_bats => 600 } } }

      it "returns correct value" do
        PlateAppearanceForecaster.project_walks(33, stats).should eq(68)
      end
    end

    describe "age 34" do
      let (:stats) { { 32 => { :at_bats => 500, :walks => 65 },
                       33 => { :at_bats => 550, :walks => 45 },
                       34 => { :at_bats => 600 } } }

      it "returns correct value" do
        PlateAppearanceForecaster.project_walks(34, stats).should eq(57)
      end
    end

    describe "ages 26, 29 thru 32 and greater than 34" do
      describe "age 26" do
        let (:stats) { { 24 => { :at_bats => 500, :walks => 65 },
                         25 => { :at_bats => 550, :walks => 45 },
                         26 => { :at_bats => 600 } } }

        it "returns correct value" do
          PlateAppearanceForecaster.project_walks(26, stats).should eq(63)
        end
      end

      describe "ages 29 thru 32" do
        let (:stats) { { 27 => { :at_bats => 500, :walks => 65 },
                         28 => { :at_bats => 550, :walks => 45 },
                         29 => { :at_bats => 600 } } }

        it "returns correct value" do
          PlateAppearanceForecaster.project_walks(29, stats).should eq(63)
        end
      end

      describe "ages greater than 34" do
        let (:stats) { { 33 => { :at_bats => 500, :walks => 65 },
                         34 => { :at_bats => 550, :walks => 45 },
                         35 => { :at_bats => 600 } } }

        it "returns correct value" do
          PlateAppearanceForecaster.project_walks(35, stats).should eq(63)
        end
      end
    end
  end

  describe "#project_at_bats" do
    describe "for ages 22 through 27" do
      let (:stats) { { 20 => { :games => 100, :at_bats => 400 },
                       21 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       22 => { :games => 100 } } }

      it "returns the correct value" do
        PlateAppearanceForecaster.project_at_bats(22, stats).should eq(395)
      end

    end

    describe "ages 28 and 29" do
      let (:stats) { { 26 => { :games => 100, :at_bats => 400 },
                       27 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       28 => { :games => 100 } } }

      it "returns the correct value" do
        PlateAppearanceForecaster.project_at_bats(28, stats).should eq(392)
      end
    end

    describe "age 30" do
      let (:stats) { { 28 => { :games => 100, :at_bats => 400 },
                       29 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       30 => { :games => 100 } } }

      it "returns the correct value" do
        PlateAppearanceForecaster.project_at_bats(30, stats).should eq(405)
      end
    end

    describe "age 31" do
      let (:stats) { { 29 => { :games => 100, :at_bats => 400 },
                       30 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       31 => { :games => 100 } } }

      it "returns the correct value" do
        PlateAppearanceForecaster.project_at_bats(31, stats).should eq(359)
      end
    end
    
    describe "ages above 31" do
      let (:stats) { { 30 => { :games => 100, :at_bats => 400 },
                       31 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       32 => { :games => 100 } } }

      it "returns the correct value" do
        PlateAppearanceForecaster.project_at_bats(32, stats).should eq(362)
      end
    end
  end
end

