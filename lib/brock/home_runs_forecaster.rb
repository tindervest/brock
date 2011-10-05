class Brock

  module HomeRunsForecaster
    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods
      def project_home_runs(age, stats)
        hits_factor = stats[age-2][:hits] + stats[age-1][:hits] + 0.0
        homer_factor = stats[age-2][:home_runs] + stats[age-1][:home_runs]
        hits_modifier = hits_modifier(age)

        (hits_modifier * stats[age][:hits] * (homer_factor / hits_factor)).round(0)
      end

      private

      def hits_modifiers
        @hits_modifiers ||= initialize_hits_modifiers
      end

      def initialize_hits_modifiers
        params = {}
        params[22..25] = 1.05
        params[26..27] = 1.15
        params[28..29] = 0.95
        params
      end

      def hits_modifier(age)
        hits_modifiers.select { |k, v| k.include?(age) }.values.pop
      end
    end
  end
end
