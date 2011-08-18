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

      :private

      def singles(stats)
        stats[:hits] - stats[:doubles] - stats[:triples] - stats[:home_runs]
      end

      def run_values_for_hits(stats)
        1.125 * singles(stats) + 1.69 * stats[:doubles] + 3.02 * stats[:triples] + 3.73 * stats[:home_runs]  
      end

      def run_values_for_secondary_stats(stats)
        0.29 * (stats[:walks] - stats[:iw] + stats[:hbp]) + 0.492 * (stats[:sf] + stats[:sh] + stats[:sb]) - 0.04 * stats[:strike_outs]
      end
    end
  end

end
