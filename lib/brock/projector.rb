require File.expand_path(File.dirname(__FILE__) + '/error')
require File.expand_path(File.dirname(__FILE__) + '/stats_service')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/hits_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/doubles_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/triples_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/home_runs_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/games_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/plate_appearance_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/runs_forecaster')
require File.expand_path(File.dirname(__FILE__) + '/forecasters/misc_forecaster')

class Brock
  module Projector

    include GamesForecaster
    include HitsForecaster
    include DoublesForecaster
    include TriplesForecaster
    include HomeRunsForecaster
    include PlateAppearanceForecaster
    include RunsForecaster
    include MiscForecaster

    class << self

      def project_career(current_age, stats, initial_sustenance)
        raise Brock::InvalidPlayerAge, "Current Age must be greater than 20" unless current_age > 20
        calculate_initial_play_factor(current_age, stats[:yearly_stats], initial_sustenance)
        forecast_rest_of_career(current_age, stats, initial_sustenance)
      end

      private 

      def raw_stats_attributes
        @raw_stat_attr ||= %w{ at_bats walks hits doubles triples home_runs } 
      end

      def forecast_rest_of_career(age, stats, initial_sustenance)
        yearly_stats, totals = stats[:yearly_stats], stats[:totals]
        project_age = age + 1

        until project_age > 41 do
          unless yearly_stats[project_age].nil? 
            forecast_raw_stats(project_age, yearly_stats)
            StatsService.initialize_stats_entry(project_age, yearly_stats[project_age], initial_sustenance)
            forecast_run_production(project_age, yearly_stats)
            finalize_forecast(project_age, yearly_stats, totals)
            break if yearly_stats[project_age][:games] == 0
          end
          project_age = project_age + 1
        end
      end

      def finalize_forecast(age, stats, totals)
        misc_stats = project_misc_stats(age, stats)
        stats[age].merge!(misc_stats)
        stats[age][:playtime][:play_factor] = StatsService.play_factor(age, stats)
        StatsService.update_totals(stats[age], totals)
      end

      def forecast_raw_stats(age, stats)
        games = stats[age][:proj_games] = project_games(age, stats)
        stats[age][:games] = StatsService.prorate_games_to_actual(stats[age][:year], games)
        stats[age][:projection] = true

        raw_stats_attributes.each do |stat|
          stats[age][stat.intern] = self.send("project_#{stat}", age, stats)
        end
      end

      def forecast_run_production(age, stats)
        stats[age][:runs] = project_runs(age, stats)
        stats[age][:rbi] = project_rbi(stats[age])
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
