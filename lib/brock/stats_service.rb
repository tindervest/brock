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
        stats[:batting_average] = batting_average(stats)
        stats[:obp] = on_base_percentage(stats)
        stats[:total_bases] = total_bases(stats)
        stats[:proj_games] = prorate_games_to_162(stats[:year], stats[:games])
        stats[:rc] = runs_created(stats)
        stats[:rc25] = runs_created_25(stats)
        stats[:sustenance] = sustenance_level(age, initial_sustenance)
        stats[:playtime][:regular] = ok_regular?(stats)
        stats[:playtime][:bench] = ok_bench?(age, stats)
      end

      def update_totals(yearly_stats, totals)
        stat_line_attributes.each_index do |index|
          stat = stat_line_attributes[index].intern
          totals[stat] += yearly_stats[stat] 
        end
      end
    end
  end
end
