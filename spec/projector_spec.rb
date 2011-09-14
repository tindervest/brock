require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/projector'
require 'brock/stats_service'

describe Brock::Projector do
  describe "#project_career" do

    it "raises exception when age to project is less than 22" do
      lambda { Brock::Projector.project_career(21, {}, 1.00) }.should raise_error(Brock::InvalidPlayerAge, "Current Age must be greater than 21")
    end

    describe "current age is less than 31" do
      let(:stats) { { 28 => { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => {} },
                      29 => { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => {} },
                      30 => { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => {} } } }

      before(:each) do
        Brock::StatsService.stub(:play_factor).with(29, stats).and_return(0.200)
        Brock::StatsService.stub(:play_factor).with(30, stats).and_return(0.500)
        Brock::Projector.project_career(30, stats, 1.00)
      end

      it "does not set the play factor for 3 years prior" do
        stats[28][:playtime][:play_factor].should be_nil
      end

      it "sets the play factor for 2 years prior" do
        stats[29][:playtime][:play_factor].should eq(0.200)
      end

      it "sets the play factor for last year" do
        stats[30][:playtime][:play_factor].should eq(0.500)
      end
    end

    describe "current age is greater than 30" do
      let(:stats) { { 29 => { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => {} },
                      30 => { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => {} },
                      31 => { :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => {} } } }

      before(:each) do
        Brock::StatsService.stub(:play_factor).with(29, stats).and_return(0.200)
        Brock::StatsService.stub(:play_factor).with(30, stats).and_return(0.500)
        Brock::StatsService.stub(:play_factor).with(31, stats).and_return(0.800)
        Brock::Projector.project_career(31, stats, 1.00)
      end
      it "sets the play factor for 3 years prior" do
        stats[29][:playtime][:play_factor].should eq(0.200)
      end

      it "sets the play factor for 2 years prior" do
        stats[30][:playtime][:play_factor].should eq(0.500)
      end

      it "sets the play factor for last year" do
        stats[31][:playtime][:play_factor].should eq(0.800)
      end
    end
  end

  describe "#project_games" do
    describe "for ages 23 through 26" do
      let(:stats) { { 21 => { :rc25 => 6.50, :playtime => { :play_factor => 1.00 } },
                      22 => { :rc25 => 5.50, :playtime => { :play_factor => 0.800 } },
                      23 => { } } }

      it "returns the correct value" do
        Brock::Projector.project_games(23, stats).should eq(124)
      end
    end

    describe "for ages 27 through 41, excluding 29 and 33" do
      let(:stats) { { 25 => { :proj_games => 144, :playtime => { :play_factor => 1.00, :regular => true } },
                      26 => { :proj_games => 132, :playtime => { :play_factor => 0.800, :regular => true } },
                      27 => { } } }

      it "returns the correct value" do
        Brock::Projector.project_games(27, stats).should eq(115)
      end
    end

    describe "for age 29" do
      let(:stats) { { 27 => { :proj_games => 144, :playtime => { :play_factor => 1.00, :regular => true } },
                      28 => { :proj_games => 132, :playtime => { :play_factor => 0.800, :regular => true } },
                      29 => { } } }
      it "returns the correct value" do
        Brock::Projector.project_games(29, stats).should eq(119)
      end
    end
  end

end
