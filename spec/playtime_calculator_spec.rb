require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/playtime_calculator'

describe "Brock::PlaytimeCalculator" do

  module Calculator 
    include Brock::PlaytimeCalculator
  end

  describe "#sustenance_level" do

    describe "calculation for age 21" do

      it "returns value for age 21" do
        validate_sustenance_calculation(21, 5.00, 4.900)
      end
    end

    describe "calculation for ages 22 through 25" do

      it "returns value for age 22" do
        validate_sustenance_calculation(22, 5.00, 4.900)
      end 

      it "returns value for age 23" do
        validate_sustenance_calculation(23, 5.00, 4.900)
      end

      it "returns value for age 24" do
        validate_sustenance_calculation(24, 5.00, 4.900)
      end

      it "returns value for age 25" do
        validate_sustenance_calculation(25, 5.00, 4.900)
      end

    end

    describe "calculation for ages 26 through 27" do

      it "returns value for age 26" do
        validate_sustenance_calculation(26, 5.00, 4.915)
      end

      it "returns value for age 27" do
        validate_sustenance_calculation(27, 5.00, 4.930)
      end
    end

    describe "calculation for ages 28 through 30" do
      it "returns value for age 28" do
        validate_sustenance_calculation(28, 5.00, 4.965)
      end

      it "returns value for age 29" do
        validate_sustenance_calculation(29, 5.00, 5.000)
      end

      it "returns value for age 30" do
        validate_sustenance_calculation(30, 5.00, 5.035)
      end
    end

    describe "calculation for age 31" do
      it "returns correct value" do
        validate_sustenance_calculation(31, 5.00, 5.080)
      end
    end

    describe "calculation for age 32" do
      it "returns correct value" do
        validate_sustenance_calculation(32, 5.00, 5.135)
      end
    end
    
    describe "calculation for age 33" do
      it "returns correct value" do
        validate_sustenance_calculation(33, 5.00, 5.205)
      end
    end

    describe "calculation for ages 34 through 36" do

      it "returns correct value for age 34" do
        validate_sustenance_calculation(34, 5.00, 5.280)
      end

      it "returns correct value for age 35" do
        validate_sustenance_calculation(35, 5.00, 5.355)
      end

      it "returns correct value for age 36" do
        validate_sustenance_calculation(36, 5.00, 5.430) 
      end
    end

    describe "calculation for age 37" do
      it "returns correct value" do
        validate_sustenance_calculation(37, 5.00, 5.480)
      end
    end

    describe "calculation for age 38" do
      it "returns correct value" do
        validate_sustenance_calculation(38, 5.00, 5.555)
      end
    end

    describe "calculation for ages 39 through 41" do
      it "returns correct value for age 39" do
        validate_sustenance_calculation(39, 5.00, 5.605)
      end

      it "returns correct value for age 40" do
        validate_sustenance_calculation(40, 5.00, 5.655)
      end

      it "returns correct value for age 41" do
        validate_sustenance_calculation(41, 5.00, 5.705)
      end
    end

    def validate_sustenance_calculation(age, initial_value, expected_value)
      result = Calculator.sustenance_level(age, initial_value)
      result.should eq(expected_value)
    end

  end
  describe "#ok_regular?" do
    it "returns true if runs created per 25 outs is greater than sustenance" do
      stats = { :rc25 => 5.67, :sustenance => 5.66 }
      Calculator.ok_regular?(stats).should be_true
    end

    it "returns false if runs created per 25 outs is less than or equal to sustenance" do
      stats = { :rc25 => 5.66, :sustenance => 5.66 }
      Calculator.ok_regular?(stats).should_not be_true
    end
  end

  describe "#ok_bench?" do
    describe "when age is less than or equal to 33" do
      let(:age) { 33 }
      it "returns true when runs created per 25 outs is greater than sustenance - 1" do
        stats = { :rc25 => 4.67, :sustenance => 5.66 }
        Calculator.ok_bench?(age, stats).should be_true
      end

      it "returns false when runs created per 25 outs is less than or equal to sustenance - 1" do
        stats = { :rc25 => 4.66, :sustenance => 5.66 }
        Calculator.ok_bench?(age, stats).should_not be_true
      end
    end

    describe "when age is greater than 33" do
      let(:age) { 34 }
      it "returns true when runs created per 25 outs is greater than sustenance - 0.6" do
        stats = { :rc25 => 5.07, :sustenance => 5.66 }
        Calculator.ok_bench?(age, stats).should be_true
      end

      it "returns false when runs created per 25 outs is less than or equal to sustenance - 0.6" do
        stats = { :rc25 => 5.06, :sustenance => 5.66 }
        Calculator.ok_bench?(age, stats).should_not be_true
      end
    end
  end

  describe "#play_factor" do
    describe "for age 20" do

      it "returns 0" do
        stats = { }
        Calculator.play_factor(20, stats).should eq(0)
      end
    end

    describe "for ages 21 through 24" do

      def validate_play_factor_for_ages_21_through_24(expected)
        stats = { 20 => { :playtime => { :bench => prior_bench} }, 21 => { :playtime => { :regular => current_regular, :bench => current_bench} } }
        Calculator.play_factor(21, stats).should eq(expected)
      end

      describe "current regular is true" do
        let(:current_regular) { true }
        let(:current_bench) { true }

        describe "prior bench is false" do
          let(:prior_bench) { false }

          it "returns 0.667" do
            validate_play_factor_for_ages_21_through_24(0.667)
          end
        end

        describe "prior bench is true" do
          let(:prior_bench) { true }

          it "returns 1.00" do
            validate_play_factor_for_ages_21_through_24(1.00)
          end
        end
      end

      describe "current regular is false" do
        let(:current_regular) { false }

        describe "current bench is true" do
          let(:current_bench) { true }

          describe "prior_bench is true" do
            let(:prior_bench) { true } 
            it "returns 0.667" do
              validate_play_factor_for_ages_21_through_24(0.667)
            end
          end

          describe "prior bench is false" do
            let(:prior_bench) { false }
            it "returns 0.333" do
              validate_play_factor_for_ages_21_through_24(0.333)
            end
          end
        end

        describe "current bench is false" do
          let(:current_bench) { false }

          describe "prior bench is false" do
            let(:prior_bench) { false }
            it "returns 0" do
              validate_play_factor_for_ages_21_through_24(0)
            end
          end

          describe "prior bench is true" do
            let(:prior_bench) { true }
            it "returns 0.333" do
              validate_play_factor_for_ages_21_through_24(0.333)
            end
          end
        end
      end
    end

    describe "for ages 25 through 30" do

      def validate_play_factor_for_ages_25_through_30(expected)
        stats = { 24 => { :playtime => { :regular => prior_regular, :bench => prior_bench } }, 25 => { :playtime => { :regular => current_regular, :bench => current_bench } } }
        Calculator.play_factor(25, stats).should eq(expected)
      end

      describe "current regular is true" do
        let(:current_regular) { true }
        let(:current_bench) { true }

        describe "prior regular is true" do
          let(:prior_regular) { true }
          let(:prior_bench) { true }

          it "returns 1.00" do
            validate_play_factor_for_ages_25_through_30(1.00)
          end

        end

        describe "prior regular is false" do
          let(:prior_regular) { false }

          describe "prior bench is true" do
            let(:prior_bench) { true }

            it "returns 0.75" do
              validate_play_factor_for_ages_25_through_30(0.75)
            end
          end

          describe "prior bench is false" do
            let(:prior_bench) { false }

            it "returns 0.50" do
              validate_play_factor_for_ages_25_through_30(0.50)
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

            it "returns 0.75" do
              validate_play_factor_for_ages_25_through_30(0.75)
            end
          end

          describe "prior regular is false" do
            let(:prior_regular) { false }
            
            describe "prior bench is true" do
              let(:prior_bench) { true }

              it "returns 0.50" do
                validate_play_factor_for_ages_25_through_30(0.50)
              end
            end

            describe "prior bench is false" do
              let(:prior_bench) { false }

              it "returns 0.25" do
                validate_play_factor_for_ages_25_through_30(0.25)
              end
            end
          end
        end

        describe "current bench is false" do
          let(:current_bench) { false }

          describe "prior regular is true" do
            let(:prior_regular) { true }
            let(:prior_bench) { true }

            it "returns 0.50" do
              validate_play_factor_for_ages_25_through_30(0.50)
            end
          end

          describe "prior regular is false" do
            let(:prior_regular) { false }
            
            describe "prior bench is true" do
              let(:prior_bench) { true }

              it "returns 0.25" do
                validate_play_factor_for_ages_25_through_30(0.25)
              end
            end

            describe "priot bench is false" do
              let(:prior_bench) { false }

              it "returns 0" do
                validate_play_factor_for_ages_25_through_30(0)
              end
            end
          end
        end
      end
    end

    describe "ages above 30" do
      def validate_play_factor_for_over_30(expected)
        stats = { 29 => { :playtime => { :regular => two_years_prior } }, 30 => { :playtime => { :regular => prior_regular, :bench => prior_bench } },
          31 => { :playtime => { :regular => current_regular, :bench => current_bench } }}
        Calculator.play_factor(31, stats).should eq(expected)
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
              validate_play_factor_for_over_30(1.00)
            end
          end

          describe "prior regular is false" do
            let(:prior_regular) { false }
            
            describe "prior bench is true" do
              let(:prior_bench) { true }

              it "returns 0.80" do
                validate_play_factor_for_over_30(0.80) 
              end
            end

            describe "prior bench is false" do
              let(:prior_bench) { false }

              it "returns 0.60" do
                validate_play_factor_for_over_30(0.60)
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
                validate_play_factor_for_over_30(0.80)
              end
            end

            describe "prior regular is false" do
              let(:prior_regular) { false }

              describe "prior bench is true" do
                let(:prior_bench) { true }

                it "returns 0.60" do
                  validate_play_factor_for_over_30(0.60)
                end

              end

              describe "prior bench is false" do
                let(:prior_bench) { false }

                it "returns 0.40" do
                  validate_play_factor_for_over_30(0.40)
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
                validate_play_factor_for_over_30(0.60)
              end
            end

            describe "prior regular is false" do
              let(:prior_regular) { false }

              describe "prior bench is true" do
                let(:prior_bench) { true }

                it "returns 0.40" do
                  validate_play_factor_for_over_30(0.40)
                end
              end

              describe "prior bench is false" do
                let(:prior_bench) { false }

                it "returns 0.20" do
                  validate_play_factor_for_over_30(0.20)
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
              validate_play_factor_for_over_30(0.80)
            end
          end

          describe "prior regular is false" do
            let(:prior_regular) { false }

            describe "prior bench is true" do
              let(:prior_bench) { true }

              it "returns 0.60" do
                validate_play_factor_for_over_30(0.60) 
              end
            end

            describe "prior bench is false" do
              let(:prior_bench) { false }

              it "returns 0.40" do
                validate_play_factor_for_over_30(0.40)
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
                validate_play_factor_for_over_30(0.60)
              end
            end

            describe "prior regular is false" do
              let(:prior_regular) { false }

              describe "prior bench is true" do
                let(:prior_bench) { true }

                it "returns 0.40" do
                  validate_play_factor_for_over_30(0.40)
                end
              end

              describe "prior bench is false" do
                let(:prior_bench) { false }

                it "returns 0.20" do
                  validate_play_factor_for_over_30(0.20)
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
                validate_play_factor_for_over_30(0.40)
              end
            end

            describe "prior regular is false" do
              let(:prior_regular) { false }

              describe "prior bench is true" do
                let(:prior_bench) { true }

                it "returns 0.20" do
                  validate_play_factor_for_over_30(0.20)
                end
              end

              describe "prior bench is false" do
                let(:prior_bench) { false }

                it "returns 0.00" do
                  validate_play_factor_for_over_30(0.00)
                end
              end
            end
          end
        end
      end
    end
  end
end
