class Brock

  module StatsCalculator

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      def total_bases(stats)
        validate_stats_hash(stats, %w{ hits doubles triples home_runs })
        
        singles(stats) + 2*stats[:doubles] + 3*stats[:triples] + 4*stats[:home_runs]
      end

      def batting_average(stats)
        validate_stats_hash(stats, %w{ hits })

        return 0 unless stats[:at_bats] > 0
        (stats[:hits] / (stats[:at_bats] + 0.0)).round(3)
      end

      def runs_created(stats)
        validate_stats_hash(stats, %w{ at_bats walks hits doubles triples home_runs stolen_bases caught_stealing gidp sf sh hbp strikeouts int_walks })

        c = stats[:at_bats] + stats[:walks] + stats[:hbp] + stats[:sh] + stats[:sf]
        return 0 unless c > 0

        a = stats[:hits] + stats[:walks] - stats[:caught_stealing] + stats[:hbp] - stats[:gidp]
        b = run_values_for_hits(stats) + run_values_for_secondary_stats(stats) 

        rc = (((2.4 * c + a) * (3 * c + b)) / (9 * c)) - (0.9 * c)

        rc > 0 ? rc.round(1) : 0
      end

      def runs_created_25(stats)
        validate_stats_hash(stats, %w{ at_bats walks hits doubles triples home_runs stolen_bases caught_stealing gidp })

        outs = outs(stats) 
        return 0 unless outs > 0

        rc = runs_created(stats)
        (rc/outs*25).round(2)
      end

      def on_base_percentage(stats)
        validate_stats_hash(stats, %w{ at_bats walks hbp sf hits })

        pa = stats[:at_bats] + stats[:walks] + stats[:hbp] + stats[:sf]
        return 0 unless pa > 0
        ob = stats[:hits] + stats[:walks] + stats[:hbp]

        ((ob + 0.0) / pa).round(3)
      end

      def slugging_percentage(stats)
        return 0 unless stats[:at_bats] > 0
        (total_bases(stats) / (stats[:at_bats] + 0.0)).round(3)
      end

      def extra_base_hits(stats)
        validate_stats_hash(stats, %w{ hits doubles triples home_runs })
        stats[:hits] - singles(stats)
      end

      private

      def singles(stats)
        stats[:hits] - stats[:doubles] - stats[:triples] - stats[:home_runs]
      end

      def outs(stats)
        stats[:at_bats] - stats[:hits] + stats[:gidp] + stats[:caught_stealing] + stats[:sf]
      end

      def run_values_for_hits(stats)
        1.125 * singles(stats) + 1.69 * stats[:doubles] + 3.02 * stats[:triples] + 3.73 * stats[:home_runs]  
      end

      def run_values_for_secondary_stats(stats)
        0.29 * (stats[:walks] - stats[:int_walks] + stats[:hbp]) + 0.492 * (stats[:sf] + stats[:sh] + stats[:stolen_bases]) - 0.04 * stats[:strikeouts]
      end
    end
  end
end
