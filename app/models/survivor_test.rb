require 'test_helper'

class SurvivorTest < ActiveSupport::TestCase
  test "should not save survivor without name" do
    survivor = Survivor.new
    assert_not survivor.save, "Saved the survivor without a name"
  end
end
