require 'rails_helper'

RSpec.describe ApplicationController, type: :system do
  describe 'error handle' do
    context 'some error check' do
      it 'Standard Error' do
        allow_any_instance_of(TasksController).to receive(:index).and_raise(StandardError, 'error')
        visit root_path
        expect(page).to have_content 'ページが表示できません'
      end

      it 'Record Not Found' do
        visit 'tasks/0'
        expect(page).to have_content 'お探しのページは見つかりません'
      end

      it 'Routing Error' do
        visit 'hoge'
        expect(page).to have_content 'お探しのページは見つかりません'
      end
    end
  end
end
