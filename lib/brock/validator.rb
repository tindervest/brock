class Brock

  module Validator

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods
      def stat_line_attributes
        @stat_attr ||= %w{ games at_bats runs hits doubles triples home_runs rbi sb cs walks strikeouts gidp hbp sh sf iw } 
      end

      def config_line_attributes
        @config_attr ||= %w{ totals_year totals_age stats_start_age current_age sustenance } 
      end

      def config_regex
        @config_rx ||= /(\d{4}|\d{2}|\d+\.\d+)+/
      end

      def line_regex
        @line_rx ||= /\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+/
      end

      def validate_config_line(line)
        raise Brock::MalformattedArgumentError, "Configuration line formatted incorrectly: #{line}" unless line.match(config_regex)
      end

      def validate_stat_line(line)
        raise Brock::MalformattedArgumentError, "Stat line formatted incorrectly: #{line}" unless line.match(line_regex)
      end

      def validate_stats_hash(stats, attributes = nil)
        attributes ||= stat_line_attributes
        attributes.each_index do |index|
          raise Brock::InvalidStatsHashError, "Stats hash must contain all elements with values: Missing element for #{attributes[index]}" unless stats[attributes[index].intern]
        end
      end
    end
  end
end
