class Brock

  module InputParser

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end

      def stats
        @stats ||= initialize_stats
      end

      def configuration
        stats[:config] ||= {}
      end

      def readData(path)
        File.open(path) do |f|
          lines = f.readlines
          lines.each_index do |index|
            extract_configuration_data(lines[index]) unless index > 0
            extract_stat_line(lines[index], index) unless index == 0
          end
        end
      end

      :private

      def initialize_stats
        stats_hash = {}
        (19..42).each do |age|
          stats_hash[age] ||= {}
        end
        return stats_hash
      end

      def extract_configuration_data(line)
        config_values = line.scan(/(\d{4}|\d{2}|\d+\.\d+)+/)
        positions = %w{ totals_year totals_age stats_start_age current_age sustenance }

        populate_hash_from_extracted_values(configuration, positions, config_values)
        configuration[:sustenance] = config_values[4][0].to_f
      end

      def extract_stat_line(line, index)
        stat_values = line.scan(/(\d+)/)
        positions = %w{ games at_bats runs hits doubles triples home_runs rbi walks }

        age = set_up_age_entry(index)
        populate_hash_from_extracted_values(stats[age], positions, stat_values) 
      end

      def set_up_age_entry(index)
        delta = calculate_stats_line_delta(index)
        age = configuration[:totals_age] + delta
        year = configuration[:totals_year] + delta
        stats[age] ||= {}
        stats[age][:year] = year 

        return age
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

    module ClassMethods
    end
  end

end
