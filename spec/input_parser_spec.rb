require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/base'
require 'fakefs'
require 'fakefs/safe'
require 'fakefs/spec_helpers'

describe Brock::InputParser do

  describe "#read_data" do
    include FakeFS::SpecHelpers

    let(:path) { "test.txt" }

    describe "reading properly formatted file" do

      before(:each) do
        
        File.open(path, 'w') do |f|
          f << "2000 28 26 29 4.67\n"
          f << "162 600 120 180 20 3 15 115 10 5 98 115 10 7 2 5 22\n" # age 26, year 1998
          f << "122 545 87 122 12 0 13 88 5 4 63 89 14 8 1 2 17\n" #age 27, year 1999
        end
        
        Brock.read_data(path)
      end

      it "contains stats hash property" do
        Brock.stats.should_not be_nil
      end

      it "contains entry for each age between 20 and 41 inclusively" do
        (20..41).each do |age|
          Brock.stats[:yearly_stats][age].should_not be_nil
        end
      end

      it "populates year for all entries" do
        (20..41).each do |age|
          Brock.stats[:yearly_stats][age][:year].should be > 0
        end
      end

      it "contains entry for cummulative stats" do
        Brock.stats[:totals].should_not be_nil
      end

      it "contains configuration hash in stats" do
        Brock.configuration.should_not be_nil
      end

      it "resets stats hash when reading data" do
        Brock.read_data(path)
        Brock.stats[:totals][:games].should eq(284)
      end

      describe "reading entire file" do
        let(:total_stats) { Brock.stats[:totals] }
        
        it "accumulates games" do
          total_stats[:games].should eq(284)
        end

        it "accumulates at bats" do
          total_stats[:at_bats].should eq(1145)
        end

        it "accumulates runs" do
          total_stats[:runs].should eq(207)
        end

        it "accumulates hits" do
          total_stats[:hits].should eq(302)
        end

        it "accumulates doubles" do
          total_stats[:doubles].should eq(32)
        end

        it "accumulates triples" do
          total_stats[:triples].should eq(3)
        end

        it "accumulates home runs" do
          total_stats[:home_runs].should eq(28)
        end

        it "accumulates rbis" do
          total_stats[:rbi].should eq(203)
        end
        
        it "accumulates stolen bases" do
          total_stats[:sb].should eq(15)
        end

        it "accumulates caught stealing" do
          total_stats[:cs].should eq(9)
        end

        it "accumulates walks" do
          total_stats[:walks].should eq(161)
        end

        it "accumulates strike outs" do
          total_stats[:strike_outs].should eq(204)
        end

        it "accumulates grounded into dp" do
          total_stats[:gidp].should eq(24)
        end

        it "accumulates hit by pitch" do
          total_stats[:hbp].should eq(15)
        end

        it "accummulates sacrifice hits" do
          total_stats[:sh].should eq(3)
        end

        it "accumulates sacrifice flies" do
          total_stats[:sf].should eq(7)
        end

        it "accumulates intentional walks" do
          total_stats[:iw].should eq(39)
        end
      end

      describe "reading specification line" do

        it "reads year of cummulative stats" do
          Brock.configuration[:totals_year].should eq(2000)
        end

        it "reads age at cummulative stats year" do
          Brock.configuration[:totals_age].should eq(28)
        end

        it "reads starting age for yearly stats" do
          Brock.configuration[:stats_start_age].should eq(26)
        end

        it "reads current age" do
          Brock.configuration[:current_age].should eq(29)
        end

        it "reads sustenance level" do
          Brock.configuration[:sustenance].should eq(4.67)
        end

      end

      describe "reading stat line" do
        let(:year_stats) { Brock.stats[:yearly_stats][27] }

        it "calculates corresponding year" do
          year_stats[:year].should eq(1999)
        end

        it "extracts games" do
          year_stats[:games].should eq(122)
        end

        it "extracts at bats" do
          year_stats[:at_bats].should eq(545)
        end

        it "extracts runs" do
          year_stats[:runs].should eq(87)
        end

        it "extracts total hits" do
          year_stats[:hits].should eq(122)
        end

        it "extracts doubles" do
          year_stats[:doubles].should eq(12)
        end

        it "extracts triples" do
          year_stats[:triples].should eq(0)
        end

        it "extracts home runs" do
          year_stats[:home_runs].should eq(13)
        end

        it "extracts rbi's" do
          year_stats[:rbi].should eq(88)
        end

        it "extracts stolen bases" do
          year_stats[:sb].should eq(5)
        end
        
        it "extracts caught stealing" do
          year_stats[:cs].should eq(4)
        end

        it "extracts walks" do
          year_stats[:walks].should eq(63)
        end

        it "extracts strikeouts" do
          year_stats[:strike_outs].should eq(89)
        end

        it "extracts double plays grounded into" do
          year_stats[:gidp].should eq(14)
        end

        it "extracts hit by pitch" do
          year_stats[:hbp].should eq(8)
        end

        it "extracts sacrifice hits" do
          year_stats[:sh].should eq(1)
        end

        it "extracts sacrifice flies" do
          year_stats[:sf].should eq(2)
        end

        it "extracts intentional walks" do
          year_stats[:iw].should eq(17)
        end

        it "calculates prorated games" do
          year_stats[:proj_games].should eq(122)
        end

        it "sets runs created per 25 outs" do
          year_stats[:rc25].should eq(3.06)
        end

        it "sets sustenance level" do
          year_stats[:sustenance].should eq(4.60)
        end

        it "sets regular playing time qualification" do
          year_stats[:playtime][:regular].should eq(false)
        end

        it "sets bench playing time qualification" do
          year_stats[:playtime][:bench].should eq(false)
        end
      end
    end

    describe "reading malformatted file" do

      describe "reading specification line" do

        before(:each) do
          File.open(path, 'w') do |f|
            f << "2XKXKX KKK"
          end
        end
      
        it "raises error when configuration line is not in correct format " do
          lambda { Brock.read_data(path) }.should raise_error(Brock::MalformattedArgumentError, "Configuration line formatted incorrectly: 2XKXKX KKK")
        end
      end

      describe "reading stat line" do
        before(:each) do
          File.open(path, 'w') do |f|
            f << "2000 28 26 29 4.67\n"
            f << "600 120 180 20 3 15 115 98\n" # age 26, year 1998
          end
        end

        it "raises error when stat line does not contain 17 numeric values separated by spaces" do
          lambda { Brock.read_data(path) }.should raise_error(Brock::MalformattedArgumentError, "Stat line formatted incorrectly: 600 120 180 20 3 15 115 98\n" )
        end
      end
    end
  end
end
