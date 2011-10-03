class Brock
  module TriplesForecaster

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end

      module ClassMethods

        def project_triples(age, stats)
          hits_modifier = age < 26 ? 1.0 : 0.89
          triples_factor = stats[age-2][:triples] + stats[age-1][:triples] + 0.0
          hits_factor = stats[age-2][:hits] + stats[age-1][:hits]

          return 0 if hits_factor == 0

          (hits_modifier * stats[age][:hits] * (triples_factor / hits_factor)).round(0)
        end
      end
    end
  end
end
