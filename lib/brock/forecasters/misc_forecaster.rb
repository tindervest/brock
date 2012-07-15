class Brock
  module MiscForecaster

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      def project_misc_stats(age, stats)
        result = {}
        rate = pa_rate(age, stats)
        misc_stats.each do |stat|
          result[stat.intern] = (stats[age-1][stat.intern] * rate).round(0)
        end
        result
      end

      private 

      def misc_stats
        @stat_attr ||= %w{ stolen_bases caught_stealing strikeouts gidp hbp sh sf int_walks } 
      end

      def pa_rate(age, stats)
        pa_current = basic_pa(stats[age]) + 0.0
        pa_prior = basic_pa(stats[age-1]) + 0.0
        return 0.0 unless pa_prior > 0.0
        (pa_current / pa_prior).round(4)
      end

      def basic_pa(stats)
        stats[:at_bats] + stats[:walks]
      end
    end
  end
end
