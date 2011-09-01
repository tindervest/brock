class Brock

  module PlaytimeCalculator

    class << self
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

      private

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
    end

  end
end
