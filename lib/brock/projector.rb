require File.expand_path(File.dirname(__FILE__) + '/error')
require File.expand_path(File.dirname(__FILE__) + '/stats_service')

class Brock
  module Projector

    class << self

      def project_career(current_age, stats, initial_sustenance)
        raise Brock::InvalidPlayerAge, "Current Age must be greater than 21" unless current_age > 21
        calculate_initial_play_factor(current_age, stats, initial_sustenance)

        project_age = current_age + 1
        
        until project_age > 41 do
          unless stats[project_age].nil? 
            games = stats[project_age][:proj_games] = project_games(project_age, stats)
            stats[project_age][:games] = Brock::StatsService.prorate_games_to_actual(stats[project_age][:year], games)
          end
          project_age = project_age + 1
        end
      end

      def project_games(age, stats)
        params = games_parameters.select { |k, v| k.include?(age) }.values.pop
        params[:projector].call(age, stats, params[:games], params[:delta])
      end

      private 

      def games_parameters
        @games_parameter ||= initialize_game_parameters
      end

      def initialize_game_parameters  
        over_26 = method(:project_games_over_26)
        under_27 = method(:project_games_under_27)
        params = {}
        params[22..24] = { :games => 149, :delta => 0, :projector => under_27 }
        params[25..25] = { :games => 144, :delta => 0, :projector => under_27 }
        params[26..26] = { :games => 149, :delta => 0, :projector => under_27 }
        params[27..28] = { :games => 154, :delta => 0, :projector => over_26 }
        params[29..29] = { :games => 154, :delta => 4, :projector => over_26 }
        params[30..33] = { :games => 154, :delta => 0, :projector => over_26 }
        params[34..41] = { :games => 150, :delta => 0, :projector => over_26 }

        return params
      end

      def calculate_initial_play_factor(current_age, stats, initial_sustenance)
        prior_years = current_age > 30 ? 2 : 1
        
        until prior_years < 0 do
          age = current_age - prior_years
          stats[age][:playtime][:play_factor] = StatsService.play_factor(age, stats)
          prior_years = prior_years - 1
        end
      end

      def project_games_under_27(age, stats, games, delta)
        ((games + stats[age-1][:rc25]) * stats[age-1][:playtime][:play_factor]).round(0) 
      end

      def project_games_over_26(age, stats, games, delta)
        regular_factor = stats[age-1][:playtime][:regular] ? 1 : 0
        projected_games = stats[age-1][:proj_games] + stats[age-2][:proj_games] 
        play_factor = stats[age-1][:playtime][:play_factor]  

        (play_factor * (projected_games + games * regular_factor) / 3 + delta).round(0)
      end
    end
  end
end
