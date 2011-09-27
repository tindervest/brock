require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/projector'
require 'brock/stats_service'

describe Brock::Projector do
  describe "#project_career" do

    it "raises exception when age to project is less than 22" do
      lambda { Brock::Projector.project_career(21, {}, 1.00) }.should raise_error(Brock::InvalidPlayerAge, "Current Age must be greater than 21")
    end

    describe "play factor calculation" do
      describe "current age is less than 31" do
        let(:stats) { { 28 => { :year => 1999, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true } },
                        29 => { :year => 2000, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true, :play_factor => 1.00 } },
                        30 => { :year => 2001, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true, :play_factor => 1.00 } } } }

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
        let(:stats) { { 29 => { :year => 1999, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true } },
                        30 => { :year => 2000, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true } },
                        31 => { :year => 2001, :games => 157, :proj_games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true } } } }

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

    describe "games played projection" do
        let(:stats) { { 29 => { :year => 1999, :proj_games => 157, :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true, :bench => true, :play_factor => 1.00 } },
                        30 => { :year => 2000, :proj_games => 157, :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        31 => { :year => 2001, :proj_games => 157, :games => 157, :at_bats => 624, :runs => 96, :hits => 207, :doubles => 32, :triples => 5, :home_runs => 28, :rbi => 99, :sb => 12, :cs => 7, :walks => 32, :strike_outs => 91, :gidp => 16, :hbp => 6, :sh => 0, :sf => 6, :iw => 7, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        32 => { :year => 2002, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        33 => { :year => 2003, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        34 => { :year => 2004, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } }, 
                        35 => { :year => 2005, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        36 => { :year => 2006, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        37 => { :year => 2007, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        38 => { :year => 2008, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        39 => { :year => 2009, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        40 => { :year => 2010, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } },
                        41 => { :year => 2011, :playtime => { :regular => true, :bench => true, :play_factor => 1.00  } } } }

        before(:each) do
          Brock::StatsService.stub(:play_factor).with(29, stats).and_return(0.200)
          Brock::StatsService.stub(:play_factor).with(30, stats).and_return(0.500)
          Brock::StatsService.stub(:play_factor).with(31, stats).and_return(0.800)
        end

        it "delegates games proration to Brock::Prorator" do
          Brock::StatsService.should_receive(:prorate_games_to_actual).exactly(10).times
          Brock::Projector.project_career(31, stats, 1.00) 
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

    describe "for ages 27 through 33, excluding 29" do
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

    describe "for ages greater than 33" do
      let(:stats) { { 32 => { :proj_games => 144, :playtime => { :play_factor => 1.00, :regular => true } },
                      33 => { :proj_games => 132, :playtime => { :play_factor => 0.800, :regular => true } },
                      34 => { } } }

      it "returns the correct value" do
        Brock::Projector.project_games(34, stats).should eq(114)
      end
    end
  end

  describe "#project_at_bats" do
    describe "for ages 22 through 27" do
      let (:stats) { { 20 => { :games => 100, :at_bats => 400 },
                       21 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       22 => { :games => 100 } } }

      it "returns the correct value" do
        Brock::Projector.project_at_bats(22, stats).should eq(395)
      end

    end

    describe "ages 28 and 29" do
      let (:stats) { { 26 => { :games => 100, :at_bats => 400 },
                       27 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       28 => { :games => 100 } } }

      it "returns the correct value" do
        Brock::Projector.project_at_bats(28, stats).should eq(392)
      end
    end

    describe "age 30" do
      let (:stats) { { 28 => { :games => 100, :at_bats => 400 },
                       29 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       30 => { :games => 100 } } }

      it "returns the correct value" do
        Brock::Projector.project_at_bats(30, stats).should eq(405)
      end
    end

    describe "age 31" do
      let (:stats) { { 29 => { :games => 100, :at_bats => 400 },
                       30 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       31 => { :games => 100 } } }

      it "returns the correct value" do
        Brock::Projector.project_at_bats(31, stats).should eq(359)
      end
    end
    
    describe "ages above 31" do
      let (:stats) { { 30 => { :games => 100, :at_bats => 400 },
                       31 => { :games => 100, :at_bats => 400, :playtime => { :play_factor => 0.800 } },
                       32 => { :games => 100 } } }

      it "returns the correct value" do
        Brock::Projector.project_at_bats(32, stats).should eq(362)
      end

    end

  end

  describe "#project_hits" do
    describe "age 22" do
      let (:stats) { { 20 => { :games => 100, :at_bats => 400, :hits => 100 },
                       21 => { :games => 100, :at_bats => 400, :hits => 120 },
                       22 => { :games => 100, :at_bats => 395 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(22, stats).should eq(115)
      end
    end

    describe "age 23" do
      let (:stats) { { 20 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       21 => { :games => 100, :at_bats => 400, :hits => 120 },
                       22 => { :games => 100, :at_bats => 395, :hits => 115 },
                       23 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(23, stats).should eq(115)
      end
    end

    describe "age 24" do
      let (:stats) { { 21 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       22 => { :games => 100, :at_bats => 400, :hits => 120 },
                       23 => { :games => 100, :at_bats => 395, :hits => 115 },
                       24 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(24, stats).should eq(116)
      end
    end

    describe "age 25" do
      let (:stats) { { 22 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       23 => { :games => 100, :at_bats => 400, :hits => 120 },
                       24 => { :games => 100, :at_bats => 395, :hits => 115 },
                       25 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(25, stats).should eq(115)
      end
    end

    describe "age 26" do
      let (:stats) { { 23 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       24 => { :games => 100, :at_bats => 400, :hits => 120 },
                       25 => { :games => 100, :at_bats => 395, :hits => 115 },
                       26 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(26, stats).should eq(113)
      end
    end

    describe "age 27" do
      let (:stats) { { 24 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       25 => { :games => 100, :at_bats => 400, :hits => 120 },
                       26 => { :games => 100, :at_bats => 395, :hits => 115 },
                       27 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(27, stats).should eq(119)
      end
    end

    describe "age 28" do
      let (:stats) { { 25 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       26 => { :games => 100, :at_bats => 400, :hits => 120 },
                       27 => { :games => 100, :at_bats => 395, :hits => 115 },
                       28 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(28, stats).should eq(108)
      end
    end

    describe "age 29" do
      let (:stats) { { 26 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       27 => { :games => 100, :at_bats => 400, :hits => 120 },
                       28 => { :games => 100, :at_bats => 395, :hits => 115 },
                       29 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(29, stats).should eq(106)
      end
    end

    describe "age 30" do
      let (:stats) { { 26 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       27 => { :games => 100, :at_bats => 400, :hits => 120 },
                       28 => { :games => 100, :at_bats => 395, :hits => 115 },
                       29 => { :games => 100, :at_bats => 400, :hits => 110 },
                       30 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(30, stats).should eq(109)
      end
    end

    describe "age 31" do
      let (:stats) { { 27 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       28 => { :games => 100, :at_bats => 400, :hits => 120 },
                       29 => { :games => 100, :at_bats => 395, :hits => 115 },
                       30 => { :games => 100, :at_bats => 400, :hits => 110 },
                       31 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(31, stats).should eq(108)
      end
    end

    describe "age 32" do
      let (:stats) { { 28 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       29 => { :games => 100, :at_bats => 400, :hits => 120 },
                       30 => { :games => 100, :at_bats => 395, :hits => 115 },
                       31 => { :games => 100, :at_bats => 400, :hits => 110 },
                       32 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(32, stats).should eq(107)
      end
    end

    describe "age 33" do
      let (:stats) { { 29 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       30 => { :games => 100, :at_bats => 400, :hits => 120 },
                       31 => { :games => 100, :at_bats => 395, :hits => 115 },
                       32 => { :games => 100, :at_bats => 400, :hits => 110 },
                       33 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(33, stats).should eq(105)
      end
    end

    describe "age 34" do
      let (:stats) { { 30 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       31 => { :games => 100, :at_bats => 400, :hits => 120 },
                       32 => { :games => 100, :at_bats => 395, :hits => 115 },
                       33 => { :games => 100, :at_bats => 400, :hits => 110 },
                       34 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(34, stats).should eq(107)
      end
    end

    describe "age 35" do
      let (:stats) { { 31 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       32 => { :games => 100, :at_bats => 400, :hits => 120 },
                       33 => { :games => 100, :at_bats => 395, :hits => 115 },
                       34 => { :games => 100, :at_bats => 400, :hits => 110 },
                       35 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(35, stats).should eq(106)
      end
    end

    describe "age 36" do
      let (:stats) { { 32 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       33 => { :games => 100, :at_bats => 400, :hits => 120 },
                       34 => { :games => 100, :at_bats => 395, :hits => 115 },
                       35 => { :games => 100, :at_bats => 400, :hits => 110 },
                       36 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(36, stats).should eq(106)
      end
    end

    describe "age 37" do
      let (:stats) { { 33 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       34 => { :games => 100, :at_bats => 400, :hits => 120 },
                       35 => { :games => 100, :at_bats => 395, :hits => 115 },
                       36 => { :games => 100, :at_bats => 400, :hits => 110 },
                       37 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(37, stats).should eq(101)
      end
    end

    describe "age 38" do
      let (:stats) { { 34 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       35 => { :games => 100, :at_bats => 400, :hits => 120 },
                       36 => { :games => 100, :at_bats => 395, :hits => 115 },
                       37 => { :games => 100, :at_bats => 400, :hits => 110 },
                       38 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(38, stats).should eq(113)
      end
    end

    describe "age 39" do
      let (:stats) { { 35 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       36 => { :games => 100, :at_bats => 400, :hits => 120 },
                       37 => { :games => 100, :at_bats => 395, :hits => 115 },
                       38 => { :games => 100, :at_bats => 400, :hits => 110 },
                       39 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(39, stats).should eq(99)
      end
    end

    describe "age 40" do
      let (:stats) { { 36 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       37 => { :games => 100, :at_bats => 400, :hits => 120 },
                       38 => { :games => 100, :at_bats => 395, :hits => 115 },
                       39 => { :games => 100, :at_bats => 400, :hits => 110 },
                       40 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(40, stats).should eq(111)
      end
    end

    describe "age 41" do
      let (:stats) { { 37 => { :games => 100, :at_bats => 400, :hits => 100 }, 
                       38 => { :games => 100, :at_bats => 400, :hits => 120 },
                       39 => { :games => 100, :at_bats => 395, :hits => 115 },
                       40 => { :games => 100, :at_bats => 400, :hits => 110 },
                       41 => { :games => 100, :at_bats => 400 } } }

      it "returns the correct value" do
        Brock::Projector.project_hits(41, stats).should eq(107)
      end
    end
  end

end
