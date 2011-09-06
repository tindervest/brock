require File.expand_path(File.dirname(__FILE__) + '/input_parser')
require File.expand_path(File.dirname(__FILE__) + '/validator')
require File.expand_path(File.dirname(__FILE__) + '/stats_calculator')

class Brock
  include InputParser
  include Validator

end
