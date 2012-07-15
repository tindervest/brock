require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock'
require 'fakefs'
require 'fakefs/safe'
require 'fakefs/spec_helpers'


describe "Brock::CSVParser" do

  describe "#read_csv_data" do
    
    shared_examples_for "individual stats parser" do
      
      it "populates year value" do
        stats[:year].should eq(2010)
      end

      it "populates games played" do
        stats[:games].should eq(100)
      end

      it "populates runs scored" do
        stats[:runs].should eq(45)
      end

      it "populates hits" do
        stats[:hits].should eq(93)
      end

      it "populates doubles" do
        stats[:doubles].should eq(21)
      end

      it "populates triples" do
        stats[:triples].should eq(1)
      end

      it "populates home runs" do
        stats[:home_runs].should eq(22)
      end

      it "populates rbis" do
        stats[:rbi].should eq(59)
      end

      it "populates stolen bases" do
        stats[:sb].should eq(5)
      end

      it "populates caught stealing" do
        stats[:cs].should eq(2)
      end

      it "populates walks" do
        stats[:walks].should eq(34)
      end

      it "populates intentional walks" do
        stats[:iw].should eq(6)
      end

      it "populates strikeouts" do
        stats[:strikeouts].should eq(123)
      end

      it "populates ground outs into double play" do
        stats[:gidp].should eq(7)
      end 

      it "populates hit by pitch" do
        stats[:hbp].should eq(2)
      end

      it "populates sacrifice hits" do
        stats[:sh].should eq(0)
      end

      it "populates sacrifice files" do
        stats[:sf].should eq(1)
      end
    end

    describe "reading from string" do

      describe "reading properly formatted string" do
        let(:contents) do
          "Year,Age,G,PA,AB,R,H,2B,3B,HR,RBI,SB,CS,BB,SO,TB,GDP,HBP,SH,SF,IBB\n" +
          "2010,19,100,396,359,45,93,21,1,22,59,5,2,34,123,182,7,2,0,1,6\n" +
          "2010,20,100,396,359,45,93,21,1,22,59,5,2,34,123,182,7,2,0,1,6\n" +
          "2011,21,150,601,516,79,135,30,5,34,87,5,5,70,166,277,11,9,0,6\n"
        end  

        before(:each) do
          Brock.read_csv_data(4.55, contents)
        end

        it "contains hash with stats" do
          Brock.stats.should_not be_nil
        end

        it "contains yearly stats" do
          Brock.stats[:yearly_stats].should_not be_nil
        end

        describe "reading individual stats entry" do

          let (:stats) { Brock.stats[:yearly_stats][20] }
          
          it_behaves_like "individual stats parser" 
        end
      end
    end

    describe "reading from file" do
      include FakeFS::SpecHelpers

      let(:path) { "test.txt" }

      before(:each) do
        File.open(path, 'w') do |f|
          f << "Year,Age,G,PA,AB,R,H,2B,3B,HR,RBI,SB,CS,BB,SO,TB,GDP,HBP,SH,SF,IBB\n"
          f << "2010,20,100,396,359,45,93,21,1,22,59,5,2,34,123,182,7,2,0,1,6\n"
          f << "2011,21,150,601,516,79,135,30,5,34,87,5,5,70,166,277,11,9,0,6\n"
        end

        Brock.read_csv_data(4.55, path)
      end
      
      describe "reading properly formatted file" do

        it "contains hash with stats" do
          Brock.stats.should_not be_nil
        end

        it "contains yearly stats" do
          Brock.stats[:yearly_stats].should_not be_nil
        end

        describe "reading individual stats entry" do
          
          let (:stats) { Brock.stats[:yearly_stats][20] }
          
          it_behaves_like "individual stats parser" 
        end
      end
    end
  end
end
