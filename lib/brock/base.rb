require File.expand_path(File.dirname(__FILE__) + '/input_parser')
require File.expand_path(File.dirname(__FILE__) + '/validator')
require File.expand_path(File.dirname(__FILE__) + '/stats_calculator')
require File.expand_path(File.dirname(__FILE__) + '/projector')

class Brock
  include InputParser
  include Validator

  class << self
    
    def project(path)
      read_data(path)
      age = configuration[:current_age]
      calculate_play_factor(age)
      Projector.project_career(age, stats)
    end

    private 

    def calculate_play_factor(current_age)
      prior_years = current_age > 30 ? 2 : 1
      
      until prior_years < 0 do
        age = current_age - prior_years
        stats[age][:playtime][:play_factor] = StatsCalculator.play_factor(age, stats)
        prior_years = prior_years - 1
      end
    end
  end
end
