require File.expand_path(File.dirname(__FILE__) + '/error')

class Brock

  module InputParser

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      def stats
        @stats ||= {}
      end

      def configuration
        stats[:config] ||= {}
      end

      def read_data(path)
        initialize_stats(stats)
        File.open(path) do |f|
          lines = f.readlines
          lines.each_index do |index|
            extract_configuration_data(lines[index]) unless index > 0
            extract_stat_line(lines[index], index) unless index == 0
          end
        end
      end

      private

      def initialize_stats(stats_hash = {})
        (20..41).each do |age|
          stats_hash[age] = {}
          stats_hash[age][:playtime] = {}
        end
        initialize_totals_entry(stats_hash)
        stats_hash
      end

      def extract_configuration_data(line)
        validate_config_line(line)

        config_values = line.scan(config_regex)
        populate_hash_from_extracted_values(configuration, config_line_attributes, config_values)
        configuration[:sustenance] = config_values[4][0].to_f
      end

      def extract_stat_line(line, index)
        validate_stat_line(line)

        stat_values = line.scan(/(\d+)/)

        age = set_up_age_entry(index)
        populate_hash_from_extracted_values(stats[age], stat_line_attributes, stat_values) 
        calculate_stats(age, stats[age])
        update_totals(stats[age])
      end

      def set_up_age_entry(index)
        delta = calculate_stats_line_delta(index)
        age = configuration[:totals_age] + delta
        year = configuration[:totals_year] + delta
        stats[age] ||= {}
        stats[age][:year] = year 

        return age
      end

      def calculate_stats(age, stats)
        stats[:proj_games] = StatsCalculator.prorate_games_played(stats[:year], stats[:games])
        stats[:rc25] = StatsCalculator.runs_created_25(stats)
        stats[:sustenance] = StatsCalculator.sustenance_level(age, configuration[:sustenance])
        stats[:playtime][:regular] = StatsCalculator.ok_regular?(stats)
        stats[:playtime][:bench] = StatsCalculator.ok_bench?(age, stats)
      end

      def calculate_stats_line_delta(index)
        years_delta = configuration[:totals_age] - configuration[:stats_start_age] 
        return index - years_delta - 1
      end

      def populate_hash_from_extracted_values(hash, positions, values)
        positions.each_index do |index|
          hash[positions[index].intern] = values[index][0].to_i
        end
      end

      def initialize_totals_entry(stats_hash)
        stats_hash[:totals] = {}
        stat_line_attributes.each_index do |index|
          stats_hash[:totals][stat_line_attributes[index].intern] = 0
        end
      end

      def update_totals(yearly_stats)
        stat_line_attributes.each_index do |index|
          stat = stat_line_attributes[index].intern
          stats[:totals][stat] += yearly_stats[stat] 
        end
      end
    end
  end
end
