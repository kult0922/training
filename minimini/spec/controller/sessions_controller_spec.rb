require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:each) do
    session[:current_user_id] = nil
    create(:user)
  end

  it 'render the login page' do
    get :new
    expect(response).to render_template(:new)
  end

  it 'fail to login with password mismatch' do
    post :create, params: {
      email: "trainee1@rakuten.com",
      password: "xxxxxxx",
    }
    expect(response).to render_template(:new)
  end

  it 'success to login' do
    post :create, params: {
      email: "trainee1@rakuten.com",
      password: "password1",
    }
    expect(response.status).to eq 302
    expect(response).to redirect_to(root_path)
  end

  it 'success to logout' do
    delete :destroy
    expect(response.status).to eq 302
    expect(response).to redirect_to(login_path)
  end

  it 'render the maintenance page during maintenance' do
    create(:maintenance_schedule)
    get :new
    expect(response.status).to eq 503
  end

  it 'render the login page after maintenance' do
    create(:maintenance_schedule, :maintenance_schedule_over)
    get :new
    expect(response).to render_template(:new)
  end
end
