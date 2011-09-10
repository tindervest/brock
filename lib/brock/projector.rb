require File.expand_path(File.dirname(__FILE__) + '/error')

class Brock
  module Projector
    class << self

      def project_career(current_age, stats)
        raise Brock::InvalidPlayerAge, "Age to project must be greater than 22" unless current_age > 22
      end

      private 

      def project_games(age)
      end
    end
  end
end

