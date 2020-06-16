require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let(:user) { FactoryBot.create(:user) }
  before do
    post admin_sessions_path, params: { email: user.email, password: user.password }
  end

  describe 'index' do
    it 'access ok' do
      get admin_users_path
      expect(response).to be_successful
    end
  end

  describe 'show' do
    it 'access ok' do
      get admin_user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'new' do
    it 'access ok' do
      get new_admin_user_path
      expect(response).to be_successful
    end
  end

  describe 'create' do
    it 'create 1 record' do
      expect {
        post admin_users_path, params: { user: FactoryBot.attributes_for(:user) }
      }.to change { User.count }.by(1)
    end
  end

  describe 'edit' do
    it 'access ok' do
      get edit_admin_user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'update' do
    it 'title change' do
      put admin_user_path(user), params: { user: { name: 'edit name' } }
      user.reload
      expect(user.name).to eq('edit name')
    end
  end

  describe 'delete' do
    context 'delete normal user' do
      let!(:normal_user) { FactoryBot.create(:user, is_admin: false) }
      it 'delete 1 record' do
        expect {
          delete admin_user_path(normal_user)
        }.to change { User.count }.by(-1)
      end
    end

    context 'delete admin user' do
      context 'two admin remain' do
        let!(:other_admin_user) { FactoryBot.create(:user) }
        it 'delete 1 record' do
          expect {
            delete admin_user_path(other_admin_user)
          }.to change { User.count }.by(-1)
        end

        context 'not delete current login admin' do
          it 'not delete record' do
            expect {
              delete admin_user_path(user)
            }.to change { User.count }.by(0)
          end
        end
      end

      context 'one admin remain' do
        it 'not delete record' do
          expect {
            delete admin_user_path(user)
          }.to change { User.count }.by(0)
        end
      end
    end
  end

  describe 'task' do
    it 'access ok' do
      get admin_user_tasks_path(user)
      expect(response).to be_successful
    end
  end
end
