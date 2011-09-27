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

      def project_at_bats(age, stats)
        params = at_bats_parameters.select { |k, v| k.include?(age) }.values.pop
        forecast_at_bats(age, stats, params)
      end

      def project_hits(age, stats)
        params = hits_parameters.select { |k, v| k.include?(age) }.values.pop
        forecast_hits(age, stats, params)
      end

      private 

      def games_parameters
        @games_parameter ||= initialize_game_parameters
      end

      def at_bats_parameters
        @at_bats_parameters ||= initialize_at_bats_parameters
      end

      def ba_deltas
        @ba_deltas ||= initialize_average_deltas
      end

      def hits_parameters
        @hits_parameters ||= initialize_hits_parameters
      end

      def forecast_at_bats(age, stats, params)
        current_games = params[:games_factor] * stats[age][:games] 
        prior_at_bats = stats[age-1][:at_bats] + stats[age-2][:at_bats] + params[:at_bats_modifier]
        prior_games = stats[age-1][:games] + stats[age-2][:games] + params[:games_modifier]
        play_factor = age < 31 ? 1.0 : (stats[age-1][:playtime][:play_factor] + 1.46) / 2.5

        return (current_games * prior_at_bats / prior_games * play_factor).round(0)
      end

      def forecast_hits(age, stats, params)
        delta = ba_deltas.select { |k, v| k.include?(age) }.values.pop
        base_factor = params[:projector].call(age, stats, delta)
        (stats[age][:at_bats] * base_factor).round(0)
      end

      def initialize_hits_parameters
        hits_22 = method(:project_hits_22)
        hits_under_30 = method(:project_hits_under_30)
        hits_over_29 = method(:project_hits_over_29)
        params = {}
        params[22..22] = { :projector => hits_22 }
        params[23..29] = { :projector => hits_under_30 }
        params[30..41] = { :projector => hits_over_29 }
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

      def initialize_at_bats_parameters
        params = {}
        params[22..27] = { :at_bats_modifier => 58, :games_modifier => 15, :games_factor => 0.99 }
        params[28..29] = { :at_bats_modifier => 51, :games_modifier => 15, :games_factor => 0.99 }
        params[30..30] = { :at_bats_modifier => 79, :games_modifier => 15, :games_factor => 0.99 }
        params[31..31] = { :at_bats_modifier => -5, :games_modifier => 0,  :games_factor => 1.00 }
        params[32..41] = { :at_bats_modifier => 0,  :games_modifier => 0,  :games_factor => 1.00 }
        params
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

      def project_hits_22(age, stats, delta)
        hits_factor = stats[age-2][:hits] + stats[age-1][:hits] + 13.0
        at_bats_factor = stats[age-2][:at_bats] + stats[age-1][:at_bats] + 50.0
        hits_factor / at_bats_factor + delta
      end

      def project_hits_under_30(age, stats, delta)
        hits_factor = stats[age-3][:hits] + stats[age-2][:hits] + (stats[age-1][:hits] / 2.0) + 13.0
        at_bats_factor = stats[age-3][:at_bats] + stats[age-2][:at_bats] + (stats[age-1][:at_bats] / 2.0) + 50.0
        hits_factor / at_bats_factor + delta
      end

      def project_hits_over_29(age, stats, delta)
        hits_factor = stats[age-4][:hits] + stats[age-3][:hits] + stats[age-2][:hits] + 12.0
        at_bats_factor = stats[age-4][:at_bats] + stats[age-3][:at_bats] + stats[age-2][:at_bats] + 50.0
        hits_factor / at_bats_factor + delta
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
