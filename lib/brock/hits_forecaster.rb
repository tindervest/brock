require File.expand_path(File.dirname(__FILE__) + '/doubles_forecaster')

class Brock
  module HitsForecaster
    include DoublesForecaster

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods
      def project_hits(age, stats)
        params = hits_parameters.select { |k, v| k.include?(age) }.values.pop
        forecast_hits(age, stats, params)
      end

      private 

      def ba_deltas
        @ba_deltas ||= initialize_average_deltas
      end

      def hits_parameters
        @hits_parameters ||= initialize_hits_parameters
      end

      def forecast_hits(age, stats, params)
        delta = ba_deltas.select { |k, v| k.include?(age) }.values.pop
        base_factor = params[:projector].call(age, stats) + delta
        (stats[age][:at_bats] * base_factor).round(0)
      end

      def initialize_hits_parameters
        params = {}
        params[22..22] = { :projector => method(:project_hits_22) }
        params[23..29] = { :projector => method(:project_hits_under_30) }
        params[30..41] = { :projector => method(:project_hits_over_29) }
        params
      end

      def initialize_average_deltas
        ba_deltas = {}
        ba_deltas[[22]]     = 0.016
        ba_deltas[[23, 25]] = 0.009
        ba_deltas[[24]]     = 0.012
        ba_deltas[[26]]     = 0.006
        ba_deltas[[27]]     = 0.020
        ba_deltas[[28, 30]] = -0.007
        ba_deltas[[29]]     = -0.013
        ba_deltas[[31]]     = -0.008
        ba_deltas[[32]]     = -0.012
        ba_deltas[[33]]     = -0.015
        ba_deltas[[34]]     = -0.011
        ba_deltas[[35, 36]] = -0.014
        ba_deltas[[37]]     = -0.025
        ba_deltas[[38]]     = 0.004
        ba_deltas[[39]]     = -0.030
        ba_deltas[[40]]     = -0.002
        ba_deltas[[41]]     = -0.010
        ba_deltas
      end

      def project_hits_22(age, stats)
        hits_factor = stats[age-2][:hits] + stats[age-1][:hits] + 13.0
        at_bats_factor = stats[age-2][:at_bats] + stats[age-1][:at_bats] + 50.0
        hits_factor / at_bats_factor
      end

      def project_hits_under_30(age, stats)
        hits_factor = stats[age-3][:hits] + stats[age-2][:hits] + (stats[age-1][:hits] / 2.0) + 13.0
        at_bats_factor = stats[age-3][:at_bats] + stats[age-2][:at_bats] + (stats[age-1][:at_bats] / 2.0) + 50.0
        hits_factor / at_bats_factor
      end

      def project_hits_over_29(age, stats)
        hits_factor = stats[age-4][:hits] + stats[age-3][:hits] + stats[age-2][:hits] + 12.0
        at_bats_factor = stats[age-4][:at_bats] + stats[age-3][:at_bats] + stats[age-2][:at_bats] + 50.0
        hits_factor / at_bats_factor
      end

    end
  end
end

