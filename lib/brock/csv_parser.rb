require 'csv'

class Brock

  module CSVParser

    def read_csv_data(initial_sustenance, path)
      initialize_stats(stats)
      configuration[:sustenance] = initial_sustenance
      age, year = populate_stats_from_csv(stats, path)
      assign_years(year, age, stats[:yearly_stats])
      age
    end

    private

    def assign_years(last_year, last_age, stats)
      if last_year > 0
        current_age = last_age + 1
        current_year = last_year + 1
        until current_age > 41 do
          stats[current_age][:year] = current_year
          current_age += 1
          current_year += 1
        end
      end
    end

    def populate_stats_from_csv(stats, path)
      yearly_stats = stats[:yearly_stats]
      age, year = 20, 0

      if path =~ /.*.txt|csv/ 
        data = CSV.read(path, :headers => true)
      else
        data = CSV.parse(path, :headers => true)
      end

      data.each do |row|
        age = row["Age"].to_i
        year = row["Year"].to_i

        year_stats = yearly_stats[age]
        populate_year_data(age, year, year_stats, stats, row) unless year_stats.nil?
      end

      [] << age << year
    end

    def populate_year_data(age, year, year_stats, stats, row)
      year_stats[:year] = year

      entry_mappings.each do |k, v|
        year_stats[k] = row[v].to_i
      end
      StatsService.initialize_stats_entry(age, year_stats, configuration[:sustenance])
      StatsService.update_totals(year_stats, stats[:totals])
    end

    def entry_mappings
      @entry_mappings ||= initialize_entry_mappings
    end

    def initialize_entry_mappings
      mappings = { :at_bats => "AB", :games => "G", :runs => "R", :hits => "H", :doubles => "2B", :triples => "3B",
                   :home_runs => "HR", :rbi => "RBI", :walks => "BB", :strikeouts => "SO", :gidp => "GDP",
                   :hbp => "HBP", :iw => "IBB", :sf => "SF", :sh => "SH", :sb => "SB", :cs => "CS" }
    end
  end
end
