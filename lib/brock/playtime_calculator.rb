class Brock

  module PlaytimeCalculator

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      def ok_regular?(stats)
        stats[:rc25] > stats[:sustenance]
      end

      def ok_bench?(age, stats)
        adjustment = age <= 33 ? 1.0 : 0.6
        stats[:rc25] > (stats[:sustenance] - adjustment)
      end

      def play_factor(age, stats)
        calculator = play_factor_calculator(age)
        calculator.call(age, stats)
      end

      def sustenance_level(age, initial_value)
        span = Range.new(21, age)
        result = initial_value
        span.each do |age| 
          adj = sustenance_adjustment(age)
          result = result + adj
        end

        return result.round(3)
      end

      private

      def sustenance_adjustment(age)
        sustenance_values.select { |k, v| k.include?(age) }.values.pop
      end

      def sustenance_values
        @sustenance_values ||= initialize_sustenance_adjustments
      end

      def play_factor_calculator(age)
        play_factor_calculators.select { |k,v| k.include?(age) }.values.pop
      end

      def play_factor_calculators
        @play_factor_calculator ||=
          { 20..20 => method(:play_factor_20),
            21..24 => method(:play_factor_21_24),
            25..30 => method(:play_factor_25_30),
            31..42 => method(:play_factor_over_30) }
      end
      
      def play_factor_20(age, stats)
        0
      end

      def play_factor_21_24(age, stats)
        ok_regular = yearly_play_categorization(age, stats)
        ok_bench = yearly_play_categorization(age, stats, false)
        ok_prior_bench = yearly_play_categorization(age-1, stats, false) 
        ((ok_regular + ok_bench + ok_prior_bench) / 3).round(3)
      end

      def play_factor_25_30(age, stats)
        ok_regular = yearly_play_categorization(age, stats)
        ok_bench = yearly_play_categorization(age, stats, false)
        ok_prior_regular = yearly_play_categorization(age-1, stats)
        ok_prior_bench = yearly_play_categorization(age-1, stats, false) 
        ((ok_regular + ok_bench + ok_prior_regular + ok_prior_bench) / 4).round(3)
      end

      def play_factor_over_30(age, stats)
        ok_regular = yearly_play_categorization(age, stats)
        ok_bench = yearly_play_categorization(age, stats, false)
        ok_prior_regular = yearly_play_categorization(age-1, stats)
        ok_prior_bench = yearly_play_categorization(age-1, stats, false)
        ok_2_prior_regular = yearly_play_categorization(age-2, stats)
        ((ok_regular + ok_bench + ok_prior_regular + ok_prior_bench + ok_2_prior_regular) / 5).round(3)
      end

      def yearly_play_categorization(age, stats, regular = true)
        value = stats[age][:playtime]
        return regular ? (value[:regular] ? 1.0 : 0.0) : (value[:bench] ? 1.0 : 0.0) 
      end

      def initialize_sustenance_adjustments
        values = {}
        values[21..21] = -0.10
        values[22..25] = 0.0
        values[26..27] = 0.015
        values[28..30] = 0.035
        values[31..31] = 0.045
        values[32..32] = 0.055
        values[33..33] = 0.070
        values[34..36] = 0.075
        values[37..37] = 0.050
        values[38..38] = 0.075
        values[39..41] = 0.050

        return values
      end
    end
  end
end
