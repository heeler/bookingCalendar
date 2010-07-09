require 'test_helper'

class InstrumentsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def setup
    UserSession.create(users(:heeler))
  end
  
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:instruments)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create instrument" do
     assert_difference('Instrument.count') do
       post :create, :instrument => {
         :id => 20, :name => "AKTA 2",
         :model => "AKTA2 FPLC", :description => "FPLC / HPLC",
         :working => true, :quota_hours => 40
        }
     end
   
     assert_redirected_to instrument_path(assigns(:instrument))
   end
 
  test "should show instrument" do
    get :show, :id => instruments(:ltq_ft).to_param
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, :id => instruments(:ltq_ft).to_param
    assert_response :success
  end
  
  test "should update instrument" do
    put :update, :id => instruments(:ltq_ft).to_param, :instrument => { :description => "New and Improved!" }
    assert_redirected_to instrument_path(assigns(:instrument))
  end
  
  test "should destroy instrument" do
    assert_difference('Instrument.count', -1) do
      delete :destroy, :id => instruments(:ltq_ft).to_param
    end
    assert_redirected_to instruments_path
  end
end
