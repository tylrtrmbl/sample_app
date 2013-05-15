require 'spec_helper'

describe "Authenticate" do
  
  subject { page }
  
  describe "sign in page" do
    before { visit signin_path }
    
    it { should have_selector('h1', text: "Sign in") }
    it { should have_full_title("Sign in") }
  end
  
  describe "sign in" do
    before { visit signin_path }
    
    describe "with invalid information" do
      before { click_button "Sign in" }
      
      it { should have_error_message "Invalid" }
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }
    
      it { should have_full_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
  
  describe "authorization" do
    
    describe "for not-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in the User controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: "Sign in") }
        end
        
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
  end
end
