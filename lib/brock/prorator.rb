class Brock

  module Prorator
    class << self
      def included(klass)
        klass.send :extend, ClassMethods
      end
    end

    module ClassMethods
      def prorate_games_played(season, games)
        season_length = strike_seasons[season] 
        season_length = season > 1960 ? 162 : 154 unless season_length
        prorated_games = games  * (162.0 / season_length)
        return prorated_games.round(1).to_i
      end

      :private
      def strike_seasons
        @strike_seasons ||= initialize_strike_seasons
      end

      def initialize_strike_seasons
        strike_seasons = { 1973 => 154, 1981 => 108, 1994 => 114, 1995 => 144 }
      end
    end
  end
end
