require File.expand_path(File.dirname(__FILE__) + '/validator')
require File.expand_path(File.dirname(__FILE__) + '/prorator')
require File.expand_path(File.dirname(__FILE__) + '/error')

class Brock

  module StatsCalculator

    include Validator
    include Prorator

    class << self
      def total_bases(stats)
        validate_stats_hash(stats)
        singles(stats) + 2*stats[:doubles] + 3*stats[:triples] + 4*stats[:home_runs]
      end

      def runs_created(stats)
        validate_stats_hash(stats)

        c = stats[:at_bats] + stats[:walks] + stats[:hbp] + stats[:sh] + stats[:sf]
        return 0 unless c > 0

        a = stats[:hits] + stats[:walks] - stats[:cs] + stats[:hbp] - stats[:gidp]
        b = run_values_for_hits(stats) + run_values_for_secondary_stats(stats) 

        rc = (((2.4 * c + a) * (3 * c + b)) / (9 * c)) - (0.9 * c)

        return rc.round(1)
      end

      def runs_created_25(stats)
        validate_stats_hash(stats)

        outs = outs(stats) 
        return 0 unless outs > 0

        rc = runs_created(stats)
        (rc/outs*25).round(2)
      end

      def sustenance_level(age, initial_value)
        span = Range.new(20, age)
        result = initial_value
        span.each do |age| 
          adj = sustenance_adjustment(age)
          result = result + adj
        end

        return result.round(3)
      end

      :private

      def sustenance_adjustment(age)
        sustenance_values.select { |k, v| k.include?(age) }.values.pop
      end

      def sustenance_values
        @sustenance_values ||= initialize_sustenance_adjustments
      end

      def singles(stats)
        stats[:hits] - stats[:doubles] - stats[:triples] - stats[:home_runs]
      end

      def outs(stats)
        stats[:at_bats] - stats[:hits] + stats[:gidp] + stats[:cs] + stats[:sf]
      end

      def run_values_for_hits(stats)
        1.125 * singles(stats) + 1.69 * stats[:doubles] + 3.02 * stats[:triples] + 3.73 * stats[:home_runs]  
      end

      def run_values_for_secondary_stats(stats)
        0.29 * (stats[:walks] - stats[:iw] + stats[:hbp]) + 0.492 * (stats[:sf] + stats[:sh] + stats[:sb]) - 0.04 * stats[:strike_outs]
      end

      def initialize_sustenance_adjustments
        values = {}
        values[20..21] = -0.10
        values[22..25] = 0.0
        values[26..27] = 0.015
        values[28..30] = 0.035
        values[31..31] = 0.045
        values[32..32] = 0.055
        values[33..33] = 0.070
        values[34..36] = 0.075
        values[37..37] = 0.050
        values[38..38] = 0.075
        values[39..42] = 0.050

        return values
      end
    end
  end

end
