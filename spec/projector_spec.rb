require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'brock/projector'

describe Brock::Projector do
  describe "project_career" do
    it "raises exception when age to project is less than 22" do
      lambda { Brock::Projector.project_career(22, {}) }.should raise_error(Brock::InvalidPlayerAge, "Age to project must be greater than 22")
    end
  end

end
