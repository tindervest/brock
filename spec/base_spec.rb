require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/base'
require 'fakefs'
require 'fakefs/safe'
require 'fakefs/spec_helpers'

describe "Brock" do
  describe "#project" do
    include FakeFS::SpecHelpers

    let(:path) { "test.txt" }

    describe "reading stats lines" do
      describe "where current age is less than 31" do
        before(:each) do
          
          File.open(path, 'w') do |f|
            f << "2000 28 26 29 4.67\n"
            f << "162 600 120 180 20 3 15 115 10 5 98 115 10 7 2 5 22\n" 
            f << "122 545 87 122 12 0 13 88 5 4 63 89 14 8 1 2 17\n" 
            f << "142 555 99 154 26 0 19 102 8 7 77 118 18 4 1 2 12\n" 
            f << "155 578 108 177 28 1 29 119 9 10 88 129 20 4 1 2 19\n" 
          end
          
          Brock.project(path)
        end
        it "sets the play factor for age 28" do
          Brock.stats[28][:playtime][:play_factor].should eq(0.500)
        end

        it "sets the play factor for age 29" do
          Brock.stats[29][:playtime][:play_factor].should eq(1.000)
        end
      end

      describe "where current age is greater than 30" do
        before(:each) do
          
          File.open(path, 'w') do |f|
            f << "2000 28 28 31 4.67\n"
            f << "162 600 120 180 20 3 15 115 10 5 98 115 10 7 2 5 22\n" 
            f << "122 545 87 122 12 0 13 88 5 4 63 89 14 8 1 2 17\n" 
            f << "142 555 99 154 26 0 19 102 8 7 77 118 18 4 1 2 12\n" 
            f << "155 578 108 177 28 1 29 119 9 10 88 129 20 4 1 2 19\n" 
          end
          
          Brock.project(path)
        end

        it "sets the play factor for age 29" do
          Brock.stats[29][:playtime][:play_factor].should eq(0.500)
        end

        it "sets the play factor for age 30" do
          Brock.stats[30][:playtime][:play_factor].should eq(0.500)
        end

        it "sets the play factor for age 31" do
          Brock.stats[31][:playtime][:play_factor].should eq(0.800)
        end
      end
    end
  end
end
