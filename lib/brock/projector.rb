require File.expand_path(File.dirname(__FILE__) + '/error')
require File.expand_path(File.dirname(__FILE__) + '/stats_service')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/hits_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/games_forecaster')


class Brock
  module Projector

    include HitsForecaster
    include GamesForecaster

    class << self

      def project_career(current_age, stats, initial_sustenance)
        raise Brock::InvalidPlayerAge, "Current Age must be greater than 21" unless current_age > 21
        calculate_initial_play_factor(current_age, stats, initial_sustenance)

        project_age = current_age + 1
        
        until project_age > 41 do
          unless stats[project_age].nil? 
            games = stats[project_age][:proj_games] = project_games(project_age, stats)
            stats[project_age][:games] = Brock::StatsService.prorate_games_to_actual(stats[project_age][:year], games)
#            stats[project_age][:at_bats] = project_at_bats(project_age, stats)
#            stats[project_age][:hits] = project_hits(project_age, stats)
          end
          project_age = project_age + 1
        end
      end

      def project_at_bats(age, stats)
        params = at_bats_parameters.select { |k, v| k.include?(age) }.values.pop
        forecast_at_bats(age, stats, params)
      end

      private 

      def at_bats_parameters
        @at_bats_parameters ||= initialize_at_bats_parameters
      end

      def forecast_at_bats(age, stats, params)
        current_games = params[:games_factor] * stats[age][:games] 
        prior_at_bats = stats[age-1][:at_bats] + stats[age-2][:at_bats] + params[:at_bats_modifier]
        prior_games = stats[age-1][:games] + stats[age-2][:games] + params[:games_modifier]
        play_factor = age < 31 ? 1.0 : (stats[age-1][:playtime][:play_factor] + 1.46) / 2.5

        return (current_games * prior_at_bats / prior_games * play_factor).round(0)
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

      def calculate_initial_play_factor(current_age, stats, initial_sustenance)
        prior_years = current_age > 30 ? 2 : 1
        
        until prior_years < 0 do
          age = current_age - prior_years
          stats[age][:playtime][:play_factor] = StatsService.play_factor(age, stats)
          prior_years = prior_years - 1
        end
      end

    end
  end
end
