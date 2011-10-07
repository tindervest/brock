class Brock
  
  module WalksForecaster
    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      def project_walks(age, stats)
        params = get_walks_params(age, stats)
        
        walks_factor = stats[age-1][:walks] + stats[age-2][:walks] + params[:walks_modifier]
        at_bats_factor = stats[age-1][:at_bats] + stats[age-2][:at_bats] + params[:at_bats_modifier]

        (params[:at_bats_factor] * stats[age][:at_bats] * (walks_factor / at_bats_factor)).round(0)
      end

      private 

      def get_walks_params(age, stats)
        params = walks_params.select { |k, v| k.include?(age) }.values.pop
        if params[:at_bats_modifier] < 0  
          total_at_bats = stats[age-1][:at_bats] + stats[age-2][:at_bats]
          params = walks_params[26..26] unless total_at_bats > params[:at_bats_modifier].abs
        end
        params
      end

      def walks_params
        @walks_params ||= initialize_walks_params
      end

      def initialize_walks_params
        params = {}
        params[22..25] = { :walks_modifier => 0.0, :at_bats_modifier => 0.0, :at_bats_factor => 1.07 }
        params[26..26] = { :walks_modifier => 10.0, :at_bats_modifier => 100.0, :at_bats_factor => 1.00 }
        params[27..27] = { :walks_modifier => 20.0, :at_bats_modifier => 100, :at_bats_factor => 1.00 }
        params[28..28] = { :walks_modifier => 0.0, :at_bats_modifier => -100, :at_bats_factor => 1.00 }
        params[29..32] = { :walks_modifier => 10.0, :at_bats_modifier => 100.0, :at_bats_factor => 1.00 }
        params[33..33] = { :walks_modifier => 20.0, :at_bats_modifier => 100, :at_bats_factor => 1.00 }
        params[34..34] = { :walks_modifier => 0.0, :at_bats_modifier => 100, :at_bats_factor => 1.00 }
        params[35..41] = { :walks_modifier => 10.0, :at_bats_modifier => 100.0, :at_bats_factor => 1.00 }
        params
      end
    end
  end
end
