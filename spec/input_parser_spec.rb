require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/input_parser'
require 'fakefs'
require 'fakefs/safe'
require 'fakefs/spec_helpers'

describe Brock::InputParser do

  describe "Initial state" do
    it "contains stats hash property" do
      Brock::InputParser.stats.should_not be_nil
    end

    it "contains entry for each age between 19 and 42 inclusively" do
      (19..42).each do |age|
        Brock::InputParser.stats[age].should_not be_nil
      end
    end

    it "contains configuration hash in stats" do
      Brock::InputParser.configuration.should_not be_nil
    end
  end

  describe "reading file input" do
    include FakeFS::SpecHelpers

    let(:path) { "/path/test.txt" }
    

    describe "reading properly formatted file" do

      before(:each) do
        
        File.open(path, 'w') do |f|
          f << "2000 28 26 29 4.67\n"
          f << "162 600 120 180 20 3 15 115 98\n" # age 26, year 1998
          f << "122 545 87  122 12 0 13 88 63\n" #age 27, year 1999
        end
        
        Brock::InputParser.readData(path)
      end

      describe "reading specification line" do

        it "reads year of cummulative stats" do
          Brock::InputParser.configuration[:totals_year].should eq(2000)
        end

        it "reads age at cummulative stats year" do
          Brock::InputParser.configuration[:totals_age].should eq(28)
        end

        it "reads starting age for yearly stats" do
          Brock::InputParser.configuration[:stats_start_age].should eq(26)
        end

        it "reads current age" do
          Brock::InputParser.configuration[:current_age].should eq(29)
        end

        it "reads sustenance level" do
          Brock::InputParser.configuration[:sustenance].should eq(4.67)
        end

      end

      describe "reading stat line" do
        let(:year_stats) { Brock::InputParser.stats[27] }

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

        it "extracts walks" do
          year_stats[:walks].should eq(63)
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
          lambda { Brock::InputParser.readData(path) }.should raise_error(Brock::MalformattedArgumentError, "Configuration line formatted incorrectly: 2XKXKX KKK")
        end

      end
    end
  end
end
