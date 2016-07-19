require "spec_helper"

RSpec.describe Abaci::Metric do

  describe ".all" do
    it "returns all stats metrics" do
      Abaci[:testing].incr
      Abaci[:tests].incr
      Abaci[:other].incr

      expect(Abaci::Metric.all).to be_kind_of(Array)
      expect(Abaci::Metric.all).to include("testing")
      expect(Abaci::Metric.all).to include("tests")
      expect(Abaci::Metric.all).to include("other")
    end

    it "is aliased as Abaci.metrics" do
      Abaci[:testing].incr
      Abaci[:tests].incr
      Abaci[:other].incr

      expect(Abaci.metrics).to be_kind_of(Array)
      expect(Abaci.metrics).to include("testing")
      expect(Abaci.metrics).to include("tests")
      expect(Abaci.metrics).to include("other")
    end
  end

end
