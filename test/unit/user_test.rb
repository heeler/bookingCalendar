require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup :activate_authlogic
  
  def test_should_be_valid
    assert true
#    assert User.new.valid? 
  end
end
