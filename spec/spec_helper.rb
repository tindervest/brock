$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'rspec'
