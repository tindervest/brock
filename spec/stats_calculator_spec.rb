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

  describe "prorate_games_played" do
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
end
