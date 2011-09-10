class Brock
  
  # Raised when invalid stat input is provided
  class MalformattedArgumentError < StandardError
  end  

  class InvalidStatsHashError < StandardError
  end

  class InvalidPlayerAge < StandardError
  end
end
