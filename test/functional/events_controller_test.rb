require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def setup    
    @inst = instruments(:ltq_orbitrap)
    @evnt = events(:orbi_event_one)
  end

  test "user should get new event" do
    user_session
    get :new, :instrument_id => 1
    assert_response :success
  end
    
  test "user should show event" do
    user_session
    get :show, :instrument_id => 1, :id => @evnt.id
    assert_response :success
  end
  
  
  test "user should create event" do
    user_session
    assert_difference('Event.count') do
      post :create, :instrument_id => 1, :event => { 
            :user_id => 1,
            :instrument_id => 1,
            :project => "88888",
            :project_pi => "Burlingame",
            :twoweekbooking => false,
            :description => "Orbitrap test booking",
            :etd => true,
            :start_at => "2010-07-18 16:00:00",
            :duration => 16.hours
             }
    end
    assert_not_nil assigns(:event), "assigns causing problems"
    assert_redirected_to instrument_path(@inst)
  end

  test "user should get edit" do
    user_session
    get :edit, :instrument_id => 1, :id => @evnt.to_param
    assert_response :success
  end
  
  test "should update event" do
    user_session
    put :update, :instrument_id => 1, :id => @evnt.to_param, :event => {:description => "newer, better, faster" }
    assert_redirected_to instrument_path(@evnt.instrument_id)
  end

  test "should destroy event" do
    user_session
    assert_difference('Event.count', -1) do
      delete :destroy, :instrument_id => 1, :id => @evnt.to_param
    end
  
    assert_redirected_to instrument_path(1)
  end
  
  private
  
  def user_session
    UserSession.create(users(:mtrnka))
  end
  
  
end
