require 'rails_helper'

RSpec.describe "Task", type: :system do
  let!(:task_status_untouch) { create(:untouch) }
  let!(:task_status_in_progress) { create(:in_progress) }
  let!(:task_status_finished) { create(:finished) }

  before do
    @untouch_id = task_status_untouch.id
    @in_progress_id = task_status_in_progress.id
    @finished_id = task_status_finished.id
    search_sample_data = {"untouch title"=>@untouch_id, "in progress title"=>@in_progress_id, "finished title"=>@finished_id}
    search_sample_data.each do |title, status_id|
      Task.create(title: title, description: "dummy description", task_status_id: status_id)
    end
  end

  describe "Create new task" do
    let(:submit) { "新規作成" }
    before { visit new_task_path }
    describe "with invalid information" do
      let(:error_message1) {"Titleを入力してください"}
      let(:error_message2) {"Descriptionを入力してください"}
      before do
        select "着手中", from: "task_task_status_id"
      end
      it "shoud respond with error and not create a task" do
        expect { click_button submit }.to change(Task, :count).by(0)
        expect(page).to have_content error_message1
        expect(page).to have_content error_message2
      end
    end

    describe "with valid information" do
      before do
        fill_in "task_title", with: "example title"
        fill_in "task_description", with: "example description"
        select "着手中", from: "task_task_status_id"
      end
      it "shoud create a task" do
        expect { click_button submit }.to change(Task, :count).by(1)
      end
    end
  end

  describe "Update task" do
    let(:submit) { "更新" }
    let(:revised_title) {"revised title"}
    let(:revised_description) {"revised description"}
    before do
      test_status = TaskStatus.find_by(name: "未着手").id
      @task = Task.create(title: 'unrivised title', description: 'unrevised description', task_status_id: test_status)
      visit "/task/" + @task.id.to_s + "/edit"
      fill_in "task_title", with: revised_title
      fill_in "task_description", with: revised_description
    end
    it "should match record with revision" do
      click_button submit
      expect(Task.find_by(id: @task.id).title).to eq revised_title
      expect(Task.find_by(id: @task.id).description).to eq revised_description
    end
  end

  describe "Delete task" do
    before do
      test_status = TaskStatus.find_by(name: "未着手").id
      @task = Task.create(title: 'test title', description: 'test description', task_status_id: test_status)
    end
    it "should delete task" do
      expect {delete "/task/" + @task.id.to_s}.to change {Task.count}.by(-1)
    end
  end

  describe "Task list page" do
    let(:test_title) {"test task 9876"}
    before do
      test_status = TaskStatus.find_by(name: "未着手").id
      Task.create(title: test_title, description: 'dummy', task_status_id: test_status)
    end
    it "should have added task title" do
      visit root_path
      expect(page).to have_content test_title
    end
  end

  describe "Task list page search" do
    let(:submit) { "検索" }
    before do
      visit root_path
    end
    it 'should show search result with correct task title' do
      select "未着手", from: "task_status_id"
      click_button submit
      expect(page).to have_content 'untouch title'

      select "着手中", from: "task_status_id"
      click_button submit
      expect(page).to have_content 'in progress title'

      select "完了", from: "task_status_id"
      click_button submit
      expect(page).to have_content 'finished title'
    end
  end
end
