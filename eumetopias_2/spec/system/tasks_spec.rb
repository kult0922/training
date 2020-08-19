require 'rails_helper'

RSpec.describe "Task", type: :system do

  describe "Create new task" do
    let(:submit) {"Save Task"}
    before { visit new_task_path }
    # DOTO:
    # 不正な値が入力されたケースはバリデーション設定後に実装する。
    # describe "with invalid information" do
    # end

    describe "with valid information" do
      before do
        fill_in "Title", with: "example title"
        fill_in "Description", with: "example description"
      end
      it "shoud create a task" do
        expect { click_button submit }.to change(Task, :count).by(1)
      end
    end
  end

  describe "Update task" do
    let(:submit) {"Update Task"}
    let(:revised_title) {"revised title"}
    let(:revised_description) {"revised description"}
    before do
      @task = Task.create(title: 'unrivised title', description: 'unrevised description')
      visit "/task/" + @task.id.to_s + "/edit"
      fill_in "Title", with: revised_title
      fill_in "Description", with: revised_description
    end
    it "should match record with revision" do
      click_button submit
      expect(Task.find_by(id: @task.id).title).to eq revised_title
      expect(Task.find_by(id: @task.id).description).to eq revised_description
    end 
  end

  describe "Delete task" do
    before do
      @task = Task.create(title: 'test title', description: 'test description')
    end
    it "shoudl delete task" do
      expect {delete "/task/" + @task.id.to_s}.to change {Task.count}.by(-1)
    end
  end

  describe "Task list page" do
    let(:test_title) {"test task 9876"}
    before do
      Task.create(title: test_title, description: 'dummy')
    end
    it "should have task title" do
      visit root_path
      expect(page).to have_content test_title
    end
  end
end
