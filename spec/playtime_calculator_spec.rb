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

  describe "#play_factor" do
    describe "for age 20" do
      it "returns 0" do
        stats = { }
        Brock::PlaytimeCalculator.play_factor(20, stats).should eq(0)
      end
    end

    describe "for ages 21 through 24" do
      it "returns 0 when current and prior year regular and bench values are false" do
        stats = { 20 => { :playtime => { :bench => false} }, 21 => { :playtime => { :regular => false, :bench => false} } }
        Brock::PlaytimeCalculator.play_factor(21, stats).should eq(0)
      end

      it "returns 0.333 when current regular and bench are false and prior bench is true" do
        stats = { 20 => { :playtime => { :bench => true} }, 21 => { :playtime => { :regular => false, :bench => false} } }
        Brock::PlaytimeCalculator.play_factor(21, stats).should eq(0.333)
      end

      it "returns 0.667 when current bench is true, current regular is false  and prior bench is true" do
        stats = { 20 => { :playtime => { :bench => true} }, 21 => { :playtime => { :regular => false, :bench => true} } }
        Brock::PlaytimeCalculator.play_factor(21, stats).should eq(0.667)
      end 

      it "returns 1 when current year regular + bench and prior year bench" do
        stats = { 20 => { :playtime => { :bench => true} }, 21 => { :playtime => { :regular => true, :bench => true} } }
        Brock::PlaytimeCalculator.play_factor(21, stats).should eq(1.00)
      end
    end

    describe "for ages 25 through 30" do
      it "returns 0 when current and prior regular and bench values are false" do
        stats = { 24 => { :playtime => { :regular => false, :bench => false } }, 25 => { :playtime => { :regular => false, :bench => false } } }
        Brock::PlaytimeCalculator.play_factor(25, stats).should eq(0.0)
      end

      it "returns 0.25 when current bench is only true category" do
        stats = { 24 => { :playtime => { :regular => false, :bench => false } }, 25 => { :playtime => { :regular => false, :bench => true } } }
        Brock::PlaytimeCalculator.play_factor(25, stats).should eq(0.25)
      end

      it "returns 0.25 when prior bench is only true category" do
        stats = { 24 => { :playtime => { :regular => false, :bench => true } }, 25 => { :playtime => { :regular => false, :bench => false } } }
        Brock::PlaytimeCalculator.play_factor(25, stats).should eq(0.25)
      end

      it "returns 0.50 when current and prior bench values are true and current and prior regular values are false" do
        stats = { 24 => { :playtime => { :regular => false, :bench => true } }, 25 => { :playtime => { :regular => false, :bench => true } } }
        Brock::PlaytimeCalculator.play_factor(25, stats).should eq(0.50)
      end

      it "returns 0.750 when current regular + bench and prior bench without prior regular" do
        stats = { 24 => { :playtime => { :regular => false, :bench => true } }, 25 => { :playtime => { :regular => true, :bench => true } } }
        Brock::PlaytimeCalculator.play_factor(25, stats).should eq(0.750)
      end

      it "returns 0.750 when prior regular + bench and current bench without current regular" do
        stats = { 24 => { :playtime => { :regular => true, :bench => true } }, 25 => { :playtime => { :regular => false, :bench => true } } }
        Brock::PlaytimeCalculator.play_factor(25, stats).should eq(0.750)
      end

      it "returns 1 when current year regular + bench and prior year regular + bench" do
        stats = { 24 => { :playtime => { :regular => true, :bench => true } }, 25 => { :playtime => { :regular => true, :bench => true } } }
        Brock::PlaytimeCalculator.play_factor(25, stats).should eq(1.00)
      end
    end

    describe "ages above 30" do
      def validate_play_factor_calculation(age, expected)
        stats = { 29 => { :playtime => { :regular => two_years_prior } }, 30 => { :playtime => { :regular => prior_regular, :bench => prior_bench } },
          31 => { :playtime => { :regular => current_regular, :bench => current_bench } }}
        Brock::PlaytimeCalculator.play_factor(age, stats).should eq(expected)
      end

      describe "2 years prior regular is true" do
        let(:two_years_prior) { true }

        describe "current regular is true" do
          let(:current_regular) { true }
          let(:current_bench) { true }

          describe "prior regular is true" do
            let(:prior_regular) { true }
            let(:prior_bench) { true }

            it "returns 1.00" do
              validate_play_factor_calculation(31, 1.00)
            end
          end

          describe "prior regular is false" do
            let(:prior_regular) { false }
            describe "prior bench is true" do
              let(:prior_bench) { true }
              it "returns 0.80" do
                validate_play_factor_calculation(31, 0.80) 
              end
            end
            describe "prior bench is false" do
              let(:prior_bench) { false }
              it "returns 0.60" do
                validate_play_factor_calculation(31, 0.60)
              end
            end
          end

        end

        describe "current regular is false" do
          let(:current_regular) { false }
          describe "current bench is true" do
            let(:current_bench) { true }
            describe "prior regular is true" do
              let(:prior_regular) { true }
              let(:prior_bench) { true }
              it "returns 0.80" do
                validate_play_factor_calculation(31, 0.80)
              end
            end
            describe "prior regular is false" do
              let(:prior_regular) { false }
              describe "prior bench is true" do
                let(:prior_bench) { true }
                it "returns 0.60" do
                  validate_play_factor_calculation(31, 0.60)
                end

              end
              describe "prior bench is false" do
                let(:prior_bench) { false }
                it "returns 0.40" do
                  validate_play_factor_calculation(31, 0.40)
                end
              end
            end
          end

          describe "current bench is false" do
            let(:current_bench) { false }
            describe "prior regular is true" do
              let(:prior_regular) { true }
              let(:prior_bench) { true }
              it "returns 0.60" do
                validate_play_factor_calculation(31, 0.60)
              end
            end
            describe "prior regular is false" do
              let(:prior_regular) { false }
              describe "prior bench is true" do
                let(:prior_bench) { true }
                it "returns 0.40" do
                  validate_play_factor_calculation(31, 0.40)
                end

              end
              describe "prior bench is false" do
                let(:prior_bench) { false }
                it "returns 0.20" do
                  validate_play_factor_calculation(31, 0.20)
                end
              end
            end
          end
        end
      end
      describe "2 years prior regular is false" do
        let(:two_years_prior) { false }

        describe "current regular is true" do
          let(:current_regular) { true }
          let(:current_bench) { true }

          describe "prior regular is true" do
            let(:prior_regular) { true }
            let(:prior_bench) { true }

            it "returns 0.80" do
              validate_play_factor_calculation(31, 0.80)
            end
          end

          describe "prior regular is false" do
            let(:prior_regular) { false }
            describe "prior bench is true" do
              let(:prior_bench) { true }
              it "returns 0.60" do
                validate_play_factor_calculation(31, 0.60) 
              end
            end
            describe "prior bench is false" do
              let(:prior_bench) { false }
              it "returns 0.40" do
                validate_play_factor_calculation(31, 0.40)
              end
            end
          end

        end

        describe "current regular is false" do
          let(:current_regular) { false }
          describe "current bench is true" do
            let(:current_bench) { true }
            describe "prior regular is true" do
              let(:prior_regular) { true }
              let(:prior_bench) { true }
              it "returns 0.60" do
                validate_play_factor_calculation(31, 0.60)
              end
            end
            describe "prior regular is false" do
              let(:prior_regular) { false }
              describe "prior bench is true" do
                let(:prior_bench) { true }
                it "returns 0.40" do
                  validate_play_factor_calculation(31, 0.40)
                end

              end
              describe "prior bench is false" do
                let(:prior_bench) { false }
                it "returns 0.20" do
                  validate_play_factor_calculation(31, 0.20)
                end
              end
            end
          end

          describe "current bench is false" do
            let(:current_bench) { false }
            describe "prior regular is true" do
              let(:prior_regular) { true }
              let(:prior_bench) { true }
              it "returns 0.40" do
                validate_play_factor_calculation(31, 0.40)
              end
            end
            describe "prior regular is false" do
              let(:prior_regular) { false }
              describe "prior bench is true" do
                let(:prior_bench) { true }
                it "returns 0.20" do
                  validate_play_factor_calculation(31, 0.20)
                end

              end
              describe "prior bench is false" do
                let(:prior_bench) { false }
                it "returns 0.00" do
                  validate_play_factor_calculation(31, 0.00)
                end
              end
            end
          end
        end
      end
    end
  end
end
