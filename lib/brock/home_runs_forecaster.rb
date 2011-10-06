class Brock

  module HomeRunsForecaster
    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods
      def project_home_runs(age, stats)
        homer_hits_ratio = home_run_to_hits_ratio(age, stats)
        hits_modifier = hits_modifier(age)

        if age < 30
          (hits_modifier * stats[age][:hits] * homer_hits_ratio).round(0)
        else
          (stats[age][:hits] * (hits_modifier + (stats[age-2][:home_runs] + stats[age-1][:home_runs] + 0.0) / 1000) * homer_hits_ratio).round(0)
        end
      end

      private

      def hits_modifiers
        @hits_modifiers ||= initialize_hits_modifiers
      end

      def home_run_to_hits_ratio(age, stats)
        hits_factor = stats[age-2][:hits] + stats[age-1][:hits] + 0.0
        homer_factor = stats[age-2][:home_runs] + stats[age-1][:home_runs]

        homer_factor / hits_factor
      end

      def initialize_hits_modifiers
        params = {}
        params[22..25] = 1.05
        params[26..27] = 1.15
        params[28..29] = 0.95
        params[30..36] = 0.86
        params[37..41] = 0.84
        params
      end

      def hits_modifier(age)
        hits_modifiers.select { |k, v| k.include?(age) }.values.pop
      end
    end
  end
end
