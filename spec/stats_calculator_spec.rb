require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/stats_calculator'

describe "Brock::StatsCalculator" do
  # Kirby Puckett 1987 Stats
  let(:valid_stats) { { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7 } }

  let(:invalid_stats) { { :year => 2000, :hits => 150, :doubles => 20, :triples => 1, :home_runs => 20} }

  let(:zero_stats) { { :games => 0, :at_bats => 0, :runs => 0, :hits => 0, :doubles => 0, :triples => 0, :home_runs => 0, :rbi => 0, :sb => 0, :cs => 0, :walks => 0, :strike_outs => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :iw => 0 } }

  describe "#total_bases" do

    it "calculates total bases" do
      Brock::StatsCalculator.total_bases(valid_stats).should eq(333)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda{ Brock::StatsCalculator.total_bases(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for games")
    end
  end

  describe "#runs_created" do
    it "returns zero when c component is zero" do
      Brock::StatsCalculator.runs_created(zero_stats).should eq(0)
    end

    it "calculates runs created using 2002 version" do
      Brock::StatsCalculator.runs_created(valid_stats).should eq(112.7)
    end

    it "should raise error when stats hash is missing any of the required keys or values" do
      lambda{ Brock::StatsCalculator.runs_created(invalid_stats) }.should raise_error(Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for games")
    end
  end

  describe "#runs_created_25" do
    it "returns zero when outs component is zero" do
      Brock::StatsCalculator.runs_created_25(zero_stats).should eq(0)
    end

    it "calculates value based on runs created per out rate" do
      Brock::StatsCalculator.runs_created_25(valid_stats).should eq(6.32)
    end
  end

  describe "#prorate_games_played" do
    describe "for non-strike seasons" do

      it "prorates based on 154 games for any season prior to 1961" do
        games = Brock::StatsCalculator.prorate_games_played(1960, 154)
        games.should eq(162)
      end

      it "prorates based on 162 games for any season after 1960" do
        games = Brock::StatsCalculator.prorate_games_played(1961, 162)
        games.should eq(162)
      end
    end

    describe "for strike seasons" do
      it "prorates 1973 season based on 154 games played" do
        games = Brock::StatsCalculator.prorate_games_played(1973, 154)
        games.should eq(162)
      end

      it "prorates 1981 season based on 108 games played" do
        games = Brock::StatsCalculator.prorate_games_played(1981, 108)
        games.should eq(162)
      end

      it "prorates 1994 season based on 114 games played" do
        games = Brock::StatsCalculator.prorate_games_played(1994, 114)
        games.should eq(162)
      end

      it "prorates 1995 season based on 144 games played" do
        games = Brock::StatsCalculator.prorate_games_played(1995, 144)
        games.should eq(162)
      end

      it "prorates partial played seasons correctly" do
        games = Brock::StatsCalculator.prorate_games_played(1919, 77)
        games.should eq(81)
      end
    end
  end

  describe "#sustenance_level" do

    describe "calculation for age 21" do
      it "returns value for age 21" do
        validate_sustenance_calculation(21, 5.00, 4.900)
      end
    end

    describe "calculation for ages 22 through 25" do

      it "returns value for age 22" do
        validate_sustenance_calculation(22, 5.00, 4.900)
      end 

      it "returns value for age 23" do
        validate_sustenance_calculation(23, 5.00, 4.900)
      end

      it "returns value for age 24" do
        validate_sustenance_calculation(24, 5.00, 4.900)
      end

      it "returns value for age 25" do
        validate_sustenance_calculation(25, 5.00, 4.900)
      end

    end

    describe "calculation for ages 26 through 27" do

      it "returns value for age 26" do
        validate_sustenance_calculation(26, 5.00, 4.915)
      end

      it "returns value for age 27" do
        validate_sustenance_calculation(27, 5.00, 4.930)
      end
    end

    describe "calculation for ages 28 through 30" do
      it "returns value for age 28" do
        validate_sustenance_calculation(28, 5.00, 4.965)
      end

      it "returns value for age 29" do
        validate_sustenance_calculation(29, 5.00, 5.000)
      end

      it "returns value for age 30" do
        validate_sustenance_calculation(30, 5.00, 5.035)
      end
    end

    describe "calculation for age 31" do
      it "returns correct value" do
        validate_sustenance_calculation(31, 5.00, 5.080)
      end
    end

    describe "calculation for age 32" do
      it "returns correct value" do
        validate_sustenance_calculation(32, 5.00, 5.135)
      end
    end
    
    describe "calculation for age 33" do
      it "returns correct value" do
        validate_sustenance_calculation(33, 5.00, 5.205)
      end
    end

    describe "calculation for ages 34 through 36" do

      it "returns correct value for age 34" do
        validate_sustenance_calculation(34, 5.00, 5.280)
      end

      it "returns correct value for age 35" do
        validate_sustenance_calculation(35, 5.00, 5.355)
      end

      it "returns correct value for age 36" do
        validate_sustenance_calculation(36, 5.00, 5.430) 
      end
    end

    describe "calculation for age 37" do
      it "returns correct value" do
        validate_sustenance_calculation(37, 5.00, 5.480)
      end
    end

    describe "calculation for age 38" do
      it "returns correct value" do
        validate_sustenance_calculation(38, 5.00, 5.555)
      end
    end

    describe "calculation for ages 39 through 41" do
      it "returns correct value for age 39" do
        validate_sustenance_calculation(39, 5.00, 5.605)
      end

      it "returns correct value for age 40" do
        validate_sustenance_calculation(40, 5.00, 5.655)
      end

      it "returns correct value for age 41" do
        validate_sustenance_calculation(41, 5.00, 5.705)
      end
    end

    def validate_sustenance_calculation(age, initial_value, expected_value)
      result = Brock::StatsCalculator.sustenance_level(age, initial_value)
      result.should eq(expected_value)
    end

  end

end
