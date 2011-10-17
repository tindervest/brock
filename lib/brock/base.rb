require File.expand_path(File.dirname(__FILE__) + '/input_parser')
require File.expand_path(File.dirname(__FILE__) + '/validator')
require File.expand_path(File.dirname(__FILE__) + '/projector')

class Brock
  include InputParser
  include Validator

  class << self
    
    def project(path)
      read_data(path)
      age = configuration[:current_age]
      Projector.project_career(age, stats, configuration[:sustenance])
    end

  end
end
