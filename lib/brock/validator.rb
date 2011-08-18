class Brock

  module Validator

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods
      def stat_line_attributes
        %w{ games at_bats runs hits doubles triples home_runs rbi sb cs walks strike_outs gidp hbp sh sf iw } 
      end

      def config_line_attributes
        %w{ totals_year totals_age stats_start_age current_age sustenance }
      end

      def config_regex
        /(\d{4}|\d{2}|\d+\.\d+)+/
      end

      def validate_config_line(line)
        config_regex = /(\d{4}|\d{2}|\d+\.\d+)+/
        raise Brock::MalformattedArgumentError, "Configuration line formatted incorrectly: #{line}" unless line.match(config_regex)
      end

      def validate_stat_line(line)
        line_regex = /\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+/
        raise Brock::MalformattedArgumentError, "Stat line formatted incorrectly: #{line}" unless line.match(line_regex)
      end

      def validate_stats_hash(stats)
        stat_line_attributes.each_index do |index|
          raise Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for #{stat_line_attributes[index]}" unless stats[stat_line_attributes[index].intern]
        end
      end
    end
  end
end
