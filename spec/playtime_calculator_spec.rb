require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/playtime_calculator'

describe "PlaytimeCalculator" do
  describe "#ok_regular?" do
    it "returns true if runs created per 25 outs is greater than sustenance" do
      stats = { :rc25 => 5.67, :sustenance => 5.66 }
      Brock::PlaytimeCalculator.ok_regular?(stats).should be_true
    end

    it "returns false if runs created per 25 outs is less than or equal to sustenance" do
      stats = { :rc25 => 5.66, :sustenance => 5.66 }
      Brock::PlaytimeCalculator.ok_regular?(stats).should_not be_true
    end
  end

  describe "#ok_bench?" do
    describe "when age is less than or equal to 33" do
      let(:age) { 33 }
      it "returns true when runs created per 25 outs is greater than sustenance - 1" do
        stats = { :rc25 => 4.67, :sustenance => 5.66 }
        Brock::PlaytimeCalculator.ok_bench?(age, stats).should be_true
      end

      it "returns false when runs created per 25 outs is less than or equal to sustenance - 1" do
        stats = { :rc25 => 4.66, :sustenance => 5.66 }
        Brock::PlaytimeCalculator.ok_bench?(age, stats).should_not be_true
      end
    end

    describe "when age is greater than 33" do
      let(:age) { 34 }
      it "returns true when runs created per 25 outs is greater than sustenance - 0.6" do
        stats = { :rc25 => 5.07, :sustenance => 5.66 }
        Brock::PlaytimeCalculator.ok_bench?(age, stats).should be_true
      end

      it "returns false when runs created per 25 outs is less than or equal to sustenance - 0.6" do
        stats = { :rc25 => 5.06, :sustenance => 5.66 }
        Brock::PlaytimeCalculator.ok_bench?(age, stats).should_not be_true
      end
    end

  end

end
