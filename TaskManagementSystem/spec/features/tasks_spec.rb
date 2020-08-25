require 'rails_helper'

RSpec.feature "Task", type: :feature do
  # タスク降順テスト
  describe 'TaskListDecendingOrder' do
    before do
      @tasks = create_list(:sample_task, 5)
    end
    it "is descending orders in task index screen" do
      # タスクが作成日時の降順になっていることを確認
      expect(Task.all.order(created_at: "DESC").map(&:created_at)).to eq @tasks.map(&:created_at).reverse!
    end  
  end
end
