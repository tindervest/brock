require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/input_parser'
require 'fakefs'
require 'fakefs/safe'
require 'fakefs/spec_helpers'

describe Brock::InputParser do

  describe "Initial state" do
    it "contains hash to manipulate input data" do
      Brock::InputParser.stats.should_not be_nil
    end
  end

  describe "reading file input" do
    include FakeFS::SpecHelpers

    describe "reading properly formatted file" do

      before(:each) do
        path = "/path/test.txt"
        
        File.open(path, 'w') do |f|
          f << "2000 28 26 29 4.67"
        end
        
        Brock::InputParser.readData(path)
      end

      describe "reading specification line" do

        it "reads year of cummulative stats" do
          Brock::InputParser.stats[:totals_year].should eq(2000)
        end

        it "reads age at cummulative stats year" do
          Brock::InputParser.stats[:totals_age].should eq(28)
        end

        it "reads starting age for yearly stats" do
          Brock::InputParser.stats[:stats_start_age].should eq(26)
        end

        it "reads current age" do
          Brock::InputParser.stats[:current_age].should eq(29)
        end

        it "reads sustenance level" do
          Brock::InputParser.stats[:sustenance].should eq(4.67)
        end

      end
    end
  end
end
