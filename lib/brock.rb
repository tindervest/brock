require File.expand_path(File.dirname(__FILE__) + '/brock/input_parser')
require File.expand_path(File.dirname(__FILE__) + '/brock/validator')
require File.expand_path(File.dirname(__FILE__) + '/brock/projector')

class Brock
  include InputParser
  include Validator

  class << self
    
    def project(path)
      read_data(path)
      age = configuration[:current_age]
      Projector.project_career(age, stats, configuration[:sustenance])
    end

    def project_csv(sustenance, path)
      age = read_csv_data(sustenance, path)
      Projector.project_career(age, stats, configuration[:sustenance])
    end
  end
end

