require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/forecasters/misc_forecaster'

describe "Brock::MiscForecaster" do
  module MiscForecaster
    include Brock::MiscForecaster
  end

  let (:stats) { { 25 => { :at_bats => 400, :walks => 50, :hbp => 10, :sf => 6, :strikeouts => 40, :int_walks => 12, :stolen_bases => 10, :caught_stealing => 5, :gidp => 12, :sh => 8 },
                   26 => { :at_bats => 200, :walks => 15 } } } 

  let (:misc_stats) {  %w{ stolen_bases caught_stealing strikeouts gidp hbp sh sf int_walks } }

  describe "#project_misc_stats" do
    it "returns hash containing keys for all misc statistics" do
      result = MiscForecaster.project_misc_stats(26, stats)
      misc_stats.each do |stat|
        result[stat.intern].should_not be_nil
      end
    end

    it "prorates misc stats based on prior year's rate per plate appearance" do
      result = MiscForecaster.project_misc_stats(26, stats)
      result[:hbp].should eq(5)
      result[:sf].should eq(3)
      result[:strikeouts].should eq(19)
      result[:int_walks].should eq(6)
      result[:stolen_bases].should eq(5)
      result[:caught_stealing].should eq(2)
      result[:gidp].should eq(6)
      result[:sh].should eq(4)
    end

    describe "given zero stats for proration" do
      let (:stats) { { 25 => { :at_bats => 0, :walks => 0, :hbp => 0, :sf => 0, :strikeouts => 0, :int_walks => 0, :stolen_bases => 0, :caught_stealing => 0, :gidp => 0, :sh => 0 },
                       26 => { :at_bats => 200, :walks => 15 } } } 

      it "returns zero for all misc stat projection" do
        result = MiscForecaster.project_misc_stats(26, stats)
        misc_stats.each do |stat|
          result[stat.intern].should eq(0)
        end
      end
    end
  end
end

