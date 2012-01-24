class Brock

  module StatsInitializer

    def initialize_stats(stats_hash = {})
      yearly_stats = stats_hash[:yearly_stats] = {}
      (20..41).each do |age|
        yearly_stats[age] = {}
        initialize_stats_entry(yearly_stats[age])
      end
      stats_hash[:totals] = {}
      initialize_stats_entry(stats_hash[:totals])
      stats_hash
    end

    def initialize_stats_entry(stats_hash)
      stats_hash[:playtime] = {}
      stats_hash[:projection] = false
      stat_line_attributes.each_index do |index|
        stats_hash[stat_line_attributes[index].intern] = 0
      end
    end
  end
end

