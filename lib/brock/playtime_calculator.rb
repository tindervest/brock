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
          { 20..20 => play_factor_20,
            21..24 => play_factor_21_24 }
      end
      
      def play_factor_20
        ->(age, stats) { 0 }
      end

      def play_factor_21_24
        ->(age, stats) do
          playtime_current = stats[age][:playtime]
          playtime_last = stats[age -1][:playtime]
          ok_regular = playtime_current[:regular] ? 1.0 : 0.0
          ok_bench = playtime_current[:bench] ? 1.0 : 0.0
          ok_prior_bench = playtime_last[:bench] ? 1.0 : 0.0 
          ((ok_regular + ok_bench + ok_prior_bench) / 3).round(3)
        end
      end
    end

  end
end
