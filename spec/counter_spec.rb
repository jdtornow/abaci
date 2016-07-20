require "spec_helper"

RSpec.describe Abaci::Counter do

  describe "#decrement" do
    it "decreases the stat by 1" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment(10)
      expect(Abaci[:testers].get).to eq(10)
      Abaci[:testers].decrement
      Abaci[:testers].decrement
      expect(Abaci[:testers].get).to eq(8)
    end

    it "decreases the stat by given value" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment(10)
      expect(Abaci[:testers].get).to eq(10)
      Abaci[:testers].decrement(2)
      expect(Abaci[:testers].get).to eq(8)
    end

    it "decreases stats using method missing" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment(10)

      Abaci.decrement_testers
      expect(Abaci[:testers].get).to eq(9)

      Abaci.decrement_testers(2)
      expect(Abaci[:testers].get).to eq(7)

      Abaci.decr_testers
      expect(Abaci[:testers].get).to eq(6)

      Abaci.decrease_testers(3)
      expect(Abaci[:testers].get).to eq(3)
    end
  end

  describe "#decrement_at" do
    it "bumps the stat on a particular date" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment(10)
      Abaci[:testers].decrement_at(1.day.ago)
      Abaci[:testers].decrement_at(15.days.ago)
      Abaci[:testers].decrement_at(20.days.ago)
      Abaci[:testers].decrement_at(35.days.ago, 3)
      expect(Abaci[:testers].get).to eq(4)
    end
  end

  describe "#del" do
    it "resets a stat" do
      Abaci[:testers].increment(10)
      expect(Abaci[:testers].get).to eq(10)
      Abaci[:testers].del
      expect(Abaci[:testers].get).to eq(0)
    end

    it "resets using method_missing" do
      Abaci[:testers].increment(10)
      expect(Abaci[:testers].get).to eq(10)

      Abaci.reset_testers!
      expect(Abaci[:testers].get).to eq(0)

      Abaci[:testers].increment(10)
      expect(Abaci[:testers].get).to eq(10)
      Abaci.clear_testers!
      expect(Abaci[:testers].get).to eq(0)
    end
  end

  describe "#get" do
    it "defaults to 0" do
      expect(Abaci[:testers].get).to eq(0)
      expect(Abaci[:something_new].get).to eq(0)
    end

    it "returns the current stat value" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment
      expect(Abaci[:testers].get).to eq(1)
    end

    it "returns the current stat value from method_missing" do
      expect(Abaci.testers).to eq(0)
      Abaci.increment_testers
      expect(Abaci.testers).to eq(1)
    end
  end

  describe "#get_last_days" do
    it "returns the number of items in the last x days" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment_at(1.day.ago)
      Abaci[:testers].increment_at(15.days.ago)
      Abaci[:testers].increment_at(20.days.ago)
      Abaci[:testers].increment_at(35.days.ago, 2)
      expect(Abaci[:testers].get).to eq(5)

      expect(Abaci[:testers].get_last_days(5)).to eq(1)
      expect(Abaci[:testers].get_last_days(15)).to eq(2)
      expect(Abaci[:testers].get_last_days(30)).to eq(3)
      expect(Abaci[:testers].get_last_days(35)).to eq(5)
    end

    it "returns the current stat value from method_missing" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment_at(1.day.ago)
      Abaci[:testers].increment_at(15.days.ago)
      Abaci[:testers].increment_at(20.days.ago)
      Abaci[:testers].increment_at(35.days.ago, 2)
      expect(Abaci[:testers].get).to eq(5)

      expect(Abaci.last_5_days_of_testers).to eq(1)
      expect(Abaci.last_15_days_of_testers).to eq(2)
      expect(Abaci.last_30_days_of_testers).to eq(3)
      expect(Abaci.last_35_days_of_testers).to eq(5)
    end
  end

  describe "#get_date" do
    it "returns the value for the given date" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment_at(1.day.ago)
      Abaci[:testers].increment_at(15.days.ago)
      expect(Abaci[:testers].get_date(15.days.ago)).to eq(1)
      expect(Abaci[:testers].get).to eq(2)
    end
  end

  describe "#increment" do
    it "bumps the stat by 1" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment
      expect(Abaci[:testers].get).to eq(1)
    end

    it "bumps the stat by given value" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment(10)
      expect(Abaci[:testers].get).to eq(10)
      Abaci[:testers].increment(2)
      expect(Abaci[:testers].get).to eq(12)
    end

    it "bumps stats using method missing" do
      expect(Abaci[:testers].get).to eq(0)

      Abaci.increment_testers
      expect(Abaci[:testers].get).to eq(1)

      Abaci.increment_testers(2)
      expect(Abaci[:testers].get).to eq(3)

      Abaci.incr_testers
      expect(Abaci[:testers].get).to eq(4)

      Abaci.increase_testers(3)
      expect(Abaci[:testers].get).to eq(7)
    end
  end

  describe "#increment_at" do
    it "bumps the stat on a particular date" do
      expect(Abaci[:testers].get).to eq(0)
      Abaci[:testers].increment_at(1.day.ago)
      Abaci[:testers].increment_at(15.days.ago)
      Abaci[:testers].increment_at(20.days.ago)
      Abaci[:testers].increment_at(35.days.ago, 2)
      expect(Abaci[:testers].get).to eq(5)
    end
  end

  describe ".all" do
    it "returns a hash of all stat keys logged" do
      expect(Abaci.all).to eq({})

      Abaci.increment_testers
      Abaci.increment_others

      expect(Abaci.all).to eq({ testers: 1, others: 1 })
    end

    it "is aliased as Abaci.summary" do
      expect(Abaci::Counter.all).to eq({})

      Abaci.increment_testers
      Abaci.increment_others

      expect(Abaci.summary).to eq({ testers: 1, others: 1 })
    end
  end

  describe ".keys" do
    it "returns a list of all stat keys logged" do
      expect(Abaci.keys).to eq([])

      Abaci.increment_testers
      expect(Abaci.keys).to include("testers")

      Abaci.increment_others
      expect(Abaci.keys).to include("others")
    end

    it "allows basic searching" do
      Abaci[:tests].incr
      Abaci[:testing].incr
      Abaci[:other].incr

      expect(Abaci.keys("test*")).to include("tests")
      expect(Abaci.keys("test*")).to include("testing")
      expect(Abaci.keys("test*")).to_not include("other")

      expect(Abaci.keys("other")).to include("other")
    end
  end

end
