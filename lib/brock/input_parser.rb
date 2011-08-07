class Brock

  module InputParser

    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end

      def stats
        @stats ||= {}
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
        stats[:totals_year] = age_data_values[0].to_i
        stats[:totals_age] = age_data_values[1].to_i
        stats[:stats_start_age] = age_data_values[2].to_i
        stats[:current_age] = age_data_values[3].to_i

        sustenance = line.scan(/\d+\.\d+/)
        stats[:sustenance] = sustenance[0].to_f
      end
    end

    module ClassMethods
    end
  end

end
