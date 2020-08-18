require 'rails_helper'

RSpec.describe "Task", type: :system do

  before { visit new_task_path }
  let(:submit) { "Save Task" }

  # DOTO: 不正な値が入力されたケース

  # 正しい値が入力されたケース
  describe "with valid information" do
    before do
      fill_in "Title", with: "example title"
      fill_in "Description", with: "example description"
    end
    it "shoud create a task" do
      # click_buttonの後、Task.countが1だけ変化する事を期待
      expect { click_button submit }.to change(Task, :count).by(1)
    end
  end
end
