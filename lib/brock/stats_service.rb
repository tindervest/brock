require File.expand_path(File.dirname(__FILE__) + '/error')
require File.expand_path(File.dirname(__FILE__) + '/stats_calculator')
require File.expand_path(File.dirname(__FILE__) + '/playtime_calculator')
require File.expand_path(File.dirname(__FILE__) + '/prorator')
require File.expand_path(File.dirname(__FILE__) + '/validator')

class Brock

  module StatsService

    include StatsCalculator
    include PlaytimeCalculator
    include Prorator
    include Validator

    class << self
      def initialize_stats_entry(age, stats, initial_sustenance)
        stats[:proj_games] = prorate_games_played(stats[:year], stats[:games])
        stats[:rc25] = runs_created_25(stats)
        stats[:sustenance] = sustenance_level(age, initial_sustenance)
        stats[:playtime][:regular] = ok_regular?(stats)
        stats[:playtime][:bench] = ok_bench?(age, stats)
      end
    end

  end

end
