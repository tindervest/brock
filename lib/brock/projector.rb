require File.expand_path(File.dirname(__FILE__) + '/error')
require File.expand_path(File.dirname(__FILE__) + '/stats_service')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/hits_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/doubles_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/triples_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/home_runs_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/games_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/walks_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/runs_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/misc_forecaster')


class Brock
  module Projector

    include GamesForecaster
    include HitsForecaster
    include DoublesForecaster
    include TriplesForecaster
    include HomeRunsForecaster
    include WalksForecaster
    include RunsForecaster
    include MiscForecaster

    class << self

      def project_career(current_age, stats, initial_sustenance)
        raise Brock::InvalidPlayerAge, "Current Age must be greater than 20" unless current_age > 20
        calculate_initial_play_factor(current_age, stats[:yearly_stats], initial_sustenance)
        forecast_rest_of_career(current_age, stats, initial_sustenance)
      end

      def project_at_bats(age, stats)
        params = at_bats_parameters.select { |k, v| k.include?(age) }.values.pop
        forecast_at_bats(age, stats, params)
      end

      private 

      def forecast_rest_of_career(age, stats, initial_sustenance)
        yearly_stats, totals = stats[:yearly_stats], stats[:totals]
        project_age = age + 1

        until project_age > 41 do
          unless yearly_stats[project_age].nil? 
            forecast_playtime(project_age, yearly_stats)
            forecast_all_hits(project_age, yearly_stats)
            StatsService.initialize_stats_entry(project_age, yearly_stats[project_age], initial_sustenance)
            forecast_run_production(project_age, yearly_stats)
            yearly_stats[project_age].merge!(project_misc_stats(project_age, yearly_stats))
            yearly_stats[project_age][:playtime][:play_factor] = StatsService.play_factor(project_age, yearly_stats)
            StatsService.update_totals(yearly_stats[project_age], totals)
            break if yearly_stats[project_age][:games] == 0
          end
          project_age = project_age + 1
        end
      end

      def forecast_playtime(age, stats)
        games = stats[age][:proj_games] = project_games(age, stats)
        stats[age][:games] = StatsService.prorate_games_to_actual(stats[age][:year], games)
        stats[age][:at_bats] = project_at_bats(age, stats)
        stats[age][:walks] = project_walks(age, stats)
      end

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

      def forecast_all_hits(age, stats)
        stats[age][:hits] = project_hits(age, stats)
        stats[age][:doubles] = project_doubles(age, stats)
        stats[age][:triples] = project_triples(age, stats)
        stats[age][:home_runs] = project_home_runs(age, stats)
      end

      def forecast_run_production(age, stats)
        stats[age][:runs] = project_runs(age, stats)
        stats[age][:rbi] = project_rbi(stats[age])
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
