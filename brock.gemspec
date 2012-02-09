Gem::Specification.new do |s|
  s.name            = 'brock'
  s.version         = '0.1.0'
  s.date            = '2012-02-01'
  s.summary         = "project baseball career for hitters"
  s.description     = "baseball brock projector based on Bill James's algorithm"
  s.authors         = ["@tindervest"]
  s.email           = 'enrtemes@gmail.com'
  s.files           = [
    "Gemfile",
    "Guardfile",
    "lib/brock.rb",
    "lib/brock/csv_parser.rb",
    "lib/brock/error.rb",
    "lib/brock/input_parser.rb",
    "lib/brock/playtime_calculator.rb",
    "lib/brock/projector.rb",
    "lib/brock/prorator.rb",
    "lib/brock/stats_calculator.rb",
    "lib/brock/stats_initializer.rb",
    "lib/brock/stats_service.rb",
    "lib/brock/validator.rb",
    "lib/brock/forecasters/doubles_forecaster.rb",
    "lib/brock/forecasters/games_forecaster.rb",
    "lib/brock/forecasters/hits_forecaster.rb",
    "lib/brock/forecasters/home_runs_forecaster.rb",
    "lib/brock/forecasters/misc_forecaster.rb",
    "lib/brock/forecasters/plate_appearance_forecaster.rb",
    "lib/brock/forecasters/runs_forecaster.rb",
    "lib/brock/forecasters/triples_forecaster.rb"
  ]
end
