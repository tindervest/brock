class Brock

  module PlaytimeCalculator

    class << self
      def ok_regular?(stats)
        stats[:rc25] > stats[:sustenance]
      end

      def ok_bench?(age, stats)
        adjustment = age <= 33 ? 1.0 : 0.6
        stats[:rc25] > (stats[:sustenance] - adjustment)
      end
    end

  end
end
