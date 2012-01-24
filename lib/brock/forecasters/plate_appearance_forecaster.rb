class Brock
  
  module PlateAppearanceForecaster
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

      def project_at_bats(age, stats)
        params = at_bats_parameters.select { |k, v| k.include?(age) }.values.pop
        forecast_at_bats(age, stats, params)
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
      
      def at_bats_parameters
        @at_bats_parameters ||= initialize_at_bats_parameters
      end

      def initialize_at_bats_parameters
        params = {}
        params[22..27] = { :at_bats_modifier => 58, :games_modifier => 15, :games_factor => 0.99 }
        params[28..29] = { :at_bats_modifier => 51, :games_modifier => 15, :games_factor => 0.99 }
        params[30..30] = { :at_bats_modifier => 79, :games_modifier => 15, :games_factor => 0.99 }
        params[31..31] = { :at_bats_modifier => -5, :games_modifier => 0,  :games_factor => 1.00 }
        params[32..41] = { :at_bats_modifier => 0,  :games_modifier => 0,  :games_factor => 1.00 }
        params
      end

      def forecast_at_bats(age, stats, params)
        current_games = params[:games_factor] * stats[age][:games] 
        prior_at_bats = stats[age-1][:at_bats] + stats[age-2][:at_bats] + params[:at_bats_modifier]
        prior_games = stats[age-1][:games] + stats[age-2][:games] + params[:games_modifier]
        play_factor = age < 31 ? 1.0 : (stats[age-1][:playtime][:play_factor] + 1.46) / 2.5

        return (current_games * prior_at_bats / prior_games * play_factor).round(0)
      end
    end
  end
end
