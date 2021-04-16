require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:each) do
    session[:current_user_id] = nil
  end

  it 'render the login page' do
    get :new
    expect(response).to render_template(:new)
  end

  it 'fail to login with password mismatch' do
    post :create, params: {
      email: "trainee5@rakuten.com",
      password: "xxxxxxx",
    }
    expect(response).to render_template(:new)
  end

  it 'success to login' do
    post :create, params: {
      email: "trainee5@rakuten.com",
      password: "password5",
    }
    expect(response.status).to eq 200
  end

  it 'success to logout' do
    post :destroy
    expect(response.status).to eq 302
  end
end
