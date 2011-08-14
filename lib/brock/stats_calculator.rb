class Brock

  module StatsCalculator

    class << self
      def total_bases(stats)
        singles = stats[:hits] - stats[:doubles] - stats[:triples] - stats[:home_runs]
        singles + 2*stats[:doubles] + 3*stats[:triples] + 4*stats[:home_runs]
      end
    end
  end

end
