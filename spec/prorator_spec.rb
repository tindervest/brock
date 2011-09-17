require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/prorator'

describe "Brock::Prorator" do
  module Prorator
    include Brock::Prorator
  end

  describe "#prorate_games_to_162" do
    describe "for non-strike seasons" do

      it "prorates based on 154 games for any season prior to 1961" do
        games = Prorator.prorate_games_to_162(1960, 154)
        games.should eq(162)
      end

      it "prorates based on 162 games for any season after 1960" do
        games = Prorator.prorate_games_to_162(1961, 162)
        games.should eq(162)
      end
    end

    describe "for strike seasons" do
      it "prorates 1973 season based on 154 games played" do
        games = Prorator.prorate_games_to_162(1973, 154)
        games.should eq(162)
      end

      it "prorates 1981 season based on 108 games played" do
        games = Prorator.prorate_games_to_162(1981, 108)
        games.should eq(162)
      end

      it "prorates 1994 season based on 114 games played" do
        games = Prorator.prorate_games_to_162(1994, 114)
        games.should eq(162)
      end

      it "prorates 1995 season based on 144 games played" do
        games = Prorator.prorate_games_to_162(1995, 144)
        games.should eq(162)
      end

      it "prorates partial played seasons correctly" do
        games = Prorator.prorate_games_to_162(1919, 77)
        games.should eq(81)
      end
    end
  end

  describe "#prorate_games_to_actual" do
    it "prorates years prior to 1961 to 154 games" do
      games = Prorator.prorate_games_to_actual(1960, 162)
      games.should eq(154)
    end

    it "prorates 1961 to 162 games" do
      games = Prorator.prorate_games_to_actual(1961, 162)
      games.should eq(162)
    end

    it "prorates 1962 to 162 games" do
      games = Prorator.prorate_games_to_actual(1962, 162)
      games.should eq(162)
    end
  end
end
