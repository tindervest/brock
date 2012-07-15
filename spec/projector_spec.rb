require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/projector'
require 'brock/stats_service'

describe Brock::Projector do
  describe "#project_career" do

    it "raises exception when current age is less than 21" do
      lambda { Brock::Projector.project_career(20, {}, 1.00) }.should raise_error(Brock::InvalidPlayerAge, "Current Age must be greater than 20")
    end

    describe "play factor calculation" do
      describe "current age is less than 31" do
        let(:stats) { { :totals => { }, :yearly_stats => { 28 => { :year => 1999, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true } },
                        29 => { :year => 2000, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true, :play_factor => 1.00 } },
                        30 => { :year => 2001, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true, :play_factor => 1.00 } } } } }

        before(:each) do
          Brock::StatsService.stub(:play_factor).with(29, stats[:yearly_stats]).and_return(0.200)
          Brock::StatsService.stub(:play_factor).with(30, stats[:yearly_stats]).and_return(0.500)
          Brock::Projector.project_career(30, stats, 1.00)
        end

        it "does not set the play factor for 3 years prior" do
          stats[:yearly_stats][28][:playtime][:play_factor].should be_nil
        end

        it "sets the play factor for 2 years prior" do
          stats[:yearly_stats][29][:playtime][:play_factor].should eq(0.200)
        end

        it "sets the play factor for last year" do
          stats[:yearly_stats][30][:playtime][:play_factor].should eq(0.500)
        end
      end

      describe "current age is greater than 30" do
        let(:stats) { { :totals => { }, :yearly_stats => { 29 => { :year => 1999, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true } },
                        30 => { :year => 2000, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true } },
                        31 => { :year => 2001, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true } } } } }

        before(:each) do
          Brock::StatsService.stub(:play_factor).with(29, stats[:yearly_stats]).and_return(0.200)
          Brock::StatsService.stub(:play_factor).with(30, stats[:yearly_stats]).and_return(0.500)
          Brock::StatsService.stub(:play_factor).with(31, stats[:yearly_stats]).and_return(0.800)
          Brock::Projector.project_career(31, stats, 1.00)
        end
        it "sets the play factor for 3 years prior" do
          stats[:yearly_stats][29][:playtime][:play_factor].should eq(0.200)
        end

        it "sets the play factor for 2 years prior" do
          stats[:yearly_stats][30][:playtime][:play_factor].should eq(0.500)
        end

        it "sets the play factor for last year" do
          stats[:yearly_stats][31][:playtime][:play_factor].should eq(0.800)
        end
      end
    end

    describe "resulting entries" do
      let(:stats) { { :totals => { :games => 0, :at_bats => 0, :runs => 0, :hits => 0, :doubles => 0, :triples => 0, :home_runs => 0, :rbi => 0,
                      :stolen_bases => 0, :caught_stealing => 0, :walks => 0, :strikeouts => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :int_walks => 0 },
                      :yearly_stats => { 28 => { :year => 1998, :proj_games => 157, :games => 157, :at_bats => 624, :runs => 96, :rc => 88, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true, :bench => true, :play_factor => 1.00 } },
                      29 => { :year => 1999, :proj_games => 157, :games => 157, :at_bats => 624, :runs => 96, :rc => 88, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true, :bench => true, :play_factor => 1.00 } },
                      30 => { :year => 2000, :proj_games => 157, :games => 157, :at_bats => 624, :runs => 96, :rc => 88, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      31 => { :year => 2001, :proj_games => 157, :games => 157, :at_bats => 624, :runs => 96, :rc => 88, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :stolen_bases => 12, :caught_stealing => 7, :walks => 32, :strikeouts => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :int_walks => 7, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      32 => { :year => 2002, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      33 => { :year => 2003, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      34 => { :year => 2004, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } }, 
                      35 => { :year => 2005, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      36 => { :year => 2006, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      37 => { :year => 2007, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      38 => { :year => 2008, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      39 => { :year => 2009, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      40 => { :year => 2010, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                      41 => { :year => 2011, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :hbp => 0, :sh => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } } } } }

      before(:each) do
        Brock::StatsService.stub(:prorate_games_to_actual).and_return(100)
      end

      describe "proration of games" do
        it "delegates games proration to Brock::Prorator" do
          Brock::StatsService.should_receive(:prorate_games_to_actual).exactly(10).times
          Brock::Projector.project_career(31, stats, 1.00) 
        end
      end

      describe "projection flag" do
        it "sets projection flag to true on all forecast entries" do
          Brock::Projector.project_career(31, stats, 1.00) 
          (32..41).each do |age|
            stats[:yearly_stats][age][:projection].should be_true
          end
        end
      end
    end
  end
end
