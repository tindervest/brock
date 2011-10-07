class Brock

  module DoublesForecaster
    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      def project_doubles(age, stats)
        doubles_adjustment = age == 35 ? 0.0 : 2.0
        hits_adjustment = age == 35 ? 7.0 : 13.0
        doubles_factor = stats[age-2][:doubles] + stats[age-1][:doubles] + doubles_adjustment
        hits_factor = stats[age-2][:hits] + stats[age-1][:hits] + hits_adjustment

        (stats[age][:hits] * (doubles_factor / hits_factor)).round(0)
      end
    end
  end
end

