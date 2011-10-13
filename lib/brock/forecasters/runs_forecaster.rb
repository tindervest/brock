class Brock

  module RunsForecaster
    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      def project_runs(age, stats)
        return 0 unless stats[age-1][:rc] > 0
        (stats[age-1][:runs] * stats[age][:rc] / stats[age-1][:rc]).round(0)
      end
    end
  end
end
