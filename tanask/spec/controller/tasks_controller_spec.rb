require 'rails_helper'

RSpec.describe 'TasksController', type: :controler do
  describe '#index' do
    it 'respences successfully' do
      get :index
      expect(responce).to be_success
    end
  end
end
