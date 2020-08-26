require 'rails_helper'

RSpec.feature "Task", type: :feature do
  # タスク降順テスト
  describe 'TaskListDecendingOrder' do
    before do
      @tasks = create_list(:valid_sample_task, 5)
    end
    it "is descending orders in task index screen" do
      # タスク一覧画面へ移動
      visit root_path

      # タスクが作成日時の降順になっていることを確認
      4.times do |n|
        expect(page.body.index(@tasks[n].created_at.strftime('%Y/%m/%d'))).to be > page.body.index(@tasks[n+1].created_at.strftime('%Y/%m/%d'))
      end
    end  
  end
end
