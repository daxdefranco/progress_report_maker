require 'spec_helper'

describe SessionsController do
  render_views
  
  describe "GET 'new'" do
    
    it "returns http success" do
      get :new
      response.should be_success
    end
  
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Log In" )
    end
    
  end

  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = {email: "", password: ""}
      end
      
      it "should render the 'new' page" do
        post :create, session: @attr
        response.should redirect_to login_path
      end
      
      it "should flash an error message" do
        post :create, session: @attr
        flash.now[:login_error].should =~ /invalid/i
      end
      
      it "should have the right title" # do
      #         post :create, session: @attr
      #         response.should have_selector('title', :content => "Log In" )
      #       end
      #       
    end
    
    describe "success" do
      
      before(:each) do
        @user = FactoryGirl.create(:user)
        @attr = { email: @user.email, password: @user.password }      
      end 
      
      it "should log the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_logged_in
      end
      
      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(root_path)
      end
      
    end
    
  end

  describe "DELETE 'destroy'" do
    
    it "should log the user out" do
      test_login(FactoryGirl.create(:user))
      delete :destroy
      controller.should_not be_logged_in
         # response.should flash 'you have logged out'  
    end
    
    it "should redirect to '/logout'" do
      test_login(FactoryGirl.create(:user))
      delete :destroy
      response.should redirect_to login_path
    end
    
  end

end
