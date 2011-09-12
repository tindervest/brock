require File.expand_path(File.dirname(__FILE__) + '/error')
require File.expand_path(File.dirname(__FILE__) + '/stats_service')

class Brock
  module Projector

    class << self
      def project_career(current_age, stats, initial_sustenance)
        raise Brock::InvalidPlayerAge, "Age to project must be greater than 22" unless current_age > 22
        calculate_initial_play_factor(current_age, stats, initial_sustenance)
      end

      private 

      def calculate_initial_play_factor(current_age, stats, initial_sustenance)
        prior_years = current_age > 30 ? 2 : 1
        
        until prior_years < 0 do
          age = current_age - prior_years
          stats[age][:playtime][:play_factor] = StatsService.play_factor(age, stats)
          prior_years = prior_years - 1
        end
      end

      def project_games(age)
      end
    end
  end
end

