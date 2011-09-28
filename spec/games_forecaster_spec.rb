require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/games_forecaster'

describe "Brock::GamesForecaster" do
  module GamesForecaster 
    include Brock::GamesForecaster
  end

  describe "#project_games" do
    describe "for ages 23 through 26" do
      let(:stats) { { 21 => { :rc25 => 6.50, :playtime => { :play_factor => 1.00 } },
                      22 => { :rc25 => 5.50, :playtime => { :play_factor => 0.800 } },
                      23 => { } } }

      it "returns the correct value" do
        GamesForecaster.project_games(23, stats).should eq(124)
      end
    end

    describe "for ages 27 through 33, excluding 29" do
      let(:stats) { { 25 => { :proj_games => 144, :playtime => { :play_factor => 1.00, :regular => true } },
                      26 => { :proj_games => 132, :playtime => { :play_factor => 0.800, :regular => true } },
                      27 => { } } }

      it "returns the correct value" do
        GamesForecaster.project_games(27, stats).should eq(115)
      end
    end

    describe "for age 29" do
      let(:stats) { { 27 => { :proj_games => 144, :playtime => { :play_factor => 1.00, :regular => true } },
                      28 => { :proj_games => 132, :playtime => { :play_factor => 0.800, :regular => true } },
                      29 => { } } }
      it "returns the correct value" do
        GamesForecaster.project_games(29, stats).should eq(119)
      end
    end

    describe "for ages greater than 33" do
      let(:stats) { { 32 => { :proj_games => 144, :playtime => { :play_factor => 1.00, :regular => true } },
                      33 => { :proj_games => 132, :playtime => { :play_factor => 0.800, :regular => true } },
                      34 => { } } }

      it "returns the correct value" do
        GamesForecaster.project_games(34, stats).should eq(114)
      end
    end
  end
end

