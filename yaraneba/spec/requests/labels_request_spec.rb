require 'rails_helper'

RSpec.describe 'Labels', type: :request do
  let!(:user) { create(:user, role_id: 'member') }
  let!(:label) { create(:label, user_id: user.id) }

  describe 'index' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        get labels_path
        expect(response).to have_http_status :ok
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        get labels_path
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'edit' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        get edit_label_path(label)
        expect(response).to have_http_status :ok
      end
    end

    context 'not logged in' do
      example 'redirect login page' do
        get edit_label_path(label)
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'update' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        patch label_path(label), params: { id: label.id, label: attributes_for(:label, name: 'sample') }
        expect(response).to have_http_status :redirect
      end

      example 'label update successfully' do
        expect do
          patch label_path(label), params: { id: label.id, label: attributes_for(:label, name: 'sample') }
        end.to change { Label.find(label.id).name }.from('label').to('sample')
      end

      context 'not allowed user' do
        example 'redirect /labels' do
          new_label = create(:label)
          patch label_path(new_label), params: { title: 'new' }
          expect(response).to redirect_to('/labels')
        end
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        patch label_path(label), params: { id: label.id, label: attributes_for(:label, name: 'sample') }
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'destroy' do
    context 'logging in' do
      before do
        post login_path, params: { email: user.email, password: user.password }
      end

      example 'response OK' do
        delete label_path(label), params: { id: label.id }
        expect(response).to have_http_status :redirect
      end

      example 'label delete successfully' do
        expect do
          delete label_path(label), params: { id: label.id }
        end.to change { Label.count }.by(-1)
      end
    end

    context 'not logged in' do
      example 'reidrect login page' do
        delete label_path(label), params: { id: label.id }
        expect(response).to redirect_to('/login')
      end
    end
  end
end
