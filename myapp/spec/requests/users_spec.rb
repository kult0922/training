# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users/:id' do
    subject(:action) do
      login_request_as(user)
      post users_path, params: params
      response
    end

    let(:params) {
      {
        user: {
          name: 'test_name',
          email: 'test_email',
          password: 'test_password',
          password_confirmation: 'test_password',
        },
      }
    }

    let(:user) { create(:user) }

    context 'when valid params' do
      it 'user is saved' do
        action

        is_expected.to have_http_status(:found)

        expect(User.count).to eq 2
        expect(flash[:notice]).to eq 'ユーザを作成しました'
      end
    end

    context 'when name is nil' do
      let(:params) { super().merge(user: { name: nil }) }

      it 'user is not saved' do
        action

        is_expected.to have_http_status(:ok)

        expect(User.count).to eq 1
        expect(flash[:notice]).to eq 'ユーザを編集に失敗しました'
      end
    end
  end

  describe 'PATCH /user/:id' do
    subject(:action) do
      login_request_as(user)
      patch "/users/#{user.id}", params: params
      response
    end

    let(:params) {
      {
        user: {
          name: 'after_name',
          email: 'after_email',
        },
      }
    }

    let(:user) { create(:user) }

    before do
      user.update(
        name: 'before_name',
        email: 'before_email',
      )
    end

    context 'when valid params' do
      it 'to be updated' do
        action

        user.reload
        is_expected.to have_http_status(:found)

        expect(user.name).to eq 'after_name'
        expect(user.email).to eq 'after_email'
      end
    end

    context 'when name is nil' do
      let(:params) { super().merge(user: { name: nil }) }

      it 'not updated' do
        action

        user.reload
        is_expected.to have_http_status(:ok)

        expect(user.name).to eq 'before_name'
        expect(flash[:notice]).to eq 'ユーザを編集に失敗しました'
      end
    end

    context 'when email is nil' do
      let(:params) { super().merge(user: { email: nil }) }

      it 'not updated' do
        action

        user.reload
        is_expected.to have_http_status(:ok)

        expect(user.email).to eq 'before_email'
      end
    end
  end

  describe 'DELETE /user/:id' do
    subject(:action) do
      login_request_as(user_1)
      delete "/users/#{user_1.id}", params: {}
      response
    end

    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user) }

    it 'status is 302' do
      action

      is_expected.to have_http_status(:found)
    end

    it 'user can be deleted' do
      expect { action }.to change { User.count }.from(2).to(1)
      expect(flash[:notice]).to eq 'ユーザを削除しました'
    end

    context 'when there is a task associated with the user' do
      let!(:task_1) { create(:task, user: user_1) }
      let!(:task_2) { create(:task, user: user_2) }

      it 'the task will also be deleted' do
        expect { action }.to change { Task.count }.from(2).to(1)
      end
    end
  end
end
