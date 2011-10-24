require File.expand_path(File.dirname(__FILE__) + '/error')
require File.expand_path(File.dirname(__FILE__) + '/stats_service')
require File.expand_path(File.dirname(__FILE__) + '/stats_initializer')
require File.expand_path(File.dirname(__FILE__) + '/csv_parser')

class Brock

  module InputParser

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods

      include StatsInitializer
      include CSVParser

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
            populate_year_for_entries if index == 1
            year_entry = extract_stat_line(lines[index], index) unless index == 0
          end
        end
      end

      private

      def populate_year_for_entries
        age = configuration[:stats_start_age] 
        year = year_from_index(1)
        stats[:yearly_stats].each do |k, v|
          v[:year] = year + k - age 
        end
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

        age = age_from_index(index)
        year_stats = stats[:yearly_stats][age]
        
        populate_hash_from_extracted_values(year_stats, stat_line_attributes, stat_values) 
        StatsService.initialize_stats_entry(age, year_stats, configuration[:sustenance])
        StatsService.update_totals(year_stats, stats[:totals])
      end

      def age_from_index(index)
        delta = calculate_stats_line_delta(index)
        age = configuration[:totals_age] + delta
      end

      def year_from_index(index)
        delta = calculate_stats_line_delta(index)
        year = configuration[:totals_year] + delta
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
    end
  end
end
