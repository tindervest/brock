class Brock

  module InputParser

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end

      def stats
        @stats ||= {}
      end

      def configuration
        stats[:config] ||= {}
      end

      def readData(path)
        File.open(path) do |f|
          f.each_line do |l|
            extract_configuration_data(l)
          end
        end
      end

      :private

      def extract_configuration_data(line)
        age_data_values = line.scan(/\d+/)
        configuration[:totals_year] = age_data_values[0].to_i
        configuration[:totals_age] = age_data_values[1].to_i
        configuration[:stats_start_age] = age_data_values[2].to_i
        configuration[:current_age] = age_data_values[3].to_i

        sustenance = line.scan(/\d+\.\d+/)
        configuration[:sustenance] = sustenance[0].to_f
      end
    end

    module ClassMethods
    end
  end

end
