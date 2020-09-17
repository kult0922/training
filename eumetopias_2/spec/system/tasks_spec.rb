require 'rails_helper'

RSpec.describe "Task", type: :system do
  let!(:task_status_untouch) { create(:untouch) }
  let!(:task_status_in_progress) { create(:in_progress) }
  let!(:task_status_finished) { create(:finished) }
  let!(:test_user) { create(:test_user) }

  describe 'with non-login status' do
    let(:task) { Task.create(title: 'dummy',
      description: 'dummy',
      task_status_id: task_status_untouch.id,
      user_id: test_user.id) }
    context 'will redirect to login_path' do
      it 'when access to root_path' do
        get '/'
        expect(response).to redirect_to(login_path)
      end
      it 'when access to task#new page' do
        get '/task/new'
        expect(response).to redirect_to(login_path)
      end
      it 'when request task#create' do
        post '/task'
        expect(response).to redirect_to(login_path)
      end
      it 'when access to task#show page' do
        get '/task/' + task.id.to_s
        expect(response).to redirect_to(login_path)
      end
      it 'when access to task#edit page' do
        get '/task/' + task.id.to_s + '/edit'
        expect(response).to redirect_to(login_path)
      end
      it 'when request task#update' do
        put '/task/' + task.id.to_s
        expect(response).to redirect_to(login_path)
      end
      it 'when request task#destroy' do
        delete '/task/' + task.id.to_s
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'with login status' do
    let(:rspec_session) { {user_id: test_user.id} }
    let!(:label1) { create(:label1) }
    let!(:label2) { create(:label2) }
    describe 'CRUD task' do
      describe "Create" do
        let(:submit) { "新規作成" }
        before { visit new_task_path }
        describe "with invalid information" do
          let(:error_message1) {"題名を入力してください"}
          let(:error_message2) {"説明を入力してください"}
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
            check '1'
          end
          it "shoud create a task" do
            expect { click_button submit }.to change(Task, :count).by(1)
          end
          describe 'task_page' do
            before do
              click_button submit
              visit task_path(Task.order('id ASC').last.id)
            end
            it 'should have correct status' do
              expect(page).to have_content '着手中'
            end
            it 'should have correct label' do
              expect(page).to have_content 'label1'
            end
          end
        end
      end

      describe "Update" do
        let(:submit) { "更新" }
        let(:revised_title) {"revised title"}
        let(:revised_description) {"revised description"}
        let(:test_status_id) { TaskStatus.find_by(name: "未着手").id }
        let(:task) {Task.create(title: 'unrivised title', description: 'unrevised description', task_status_id: test_status_id, user_id: test_user.id, label_ids: [label1.id]) }
        before do
          visit edit_task_path(@task.id)
          fill_in "task_title", with: revised_title
          fill_in "task_description", with: revised_description
          select "完了", from: "task_task_status_id"
          uncheck 1
          check 2
        end
        it "should match record with revision" do
          click_button submit
          revised_task = Task.find_by(id: task.id)
          expect(revised_task.title).to eq revised_title
          expect(revised_task.description).to eq revised_description
          expect(revised_task.task_status.name).to eq "完了"
          expect(revised_task.labels.map(&:name)).not_to include label1.name
          expect(revised_task.labels.map(&:name)).to include label2.name
        end
      end

      describe "Delete" do
        let(:test_status) { TaskStatus.find_by(name: "未着手").id }
        let!(:task) { Task.create(title: 'test title',
          description: 'test description',
          task_status_id: test_status,
          user_id: test_user.id) }
        it "should delete task" do
          expect {delete "/task/" + task.id.to_s}.to change {Task.count}.by(-1)
        end
      end
      describe "Added" do
        let(:test_title) {"test task 9876"}
        before do
          test_status = TaskStatus.find_by(name: "未着手").id
          Task.create(title: test_title,
            description: 'dummy',
            task_status_id: test_status,
            user_id: test_user.id)
        end
        it "should show in task list page" do
          visit root_path
          expect(page).to have_content test_title
        end
      end
    end

    describe "Task list page function" do
      let(:untouch_id) { task_status_untouch.id }
      let(:in_progress_id) { task_status_in_progress.id }
      let(:finished_id) { task_status_finished.id }
      describe "search" do
        let(:submit) { "検索" }
        describe "by status" do
          before do
            search_sample_data = [
              {title: "untouch title", status_id: untouch_id},
              {title: "in progress title", status_id: in_progress_id},
              {title: "finished title", status_id: finished_id}
            ]
            search_sample_data.each do |sample|
              Task.create(title: sample[:title], description: "dummy description", task_status_id: sample[:status_id], user_id: test_user.id)
            end
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

        describe "by label" do
          before do
            Task.create(title: 'label search test', description: 'test description', task_status_id: untouch_id, user_id: test_user.id, label_ids: [label1.id])
            visit root_path
          end
          it 'should show search result with correct task title' do
            select label1.name, from: "label_id"
            click_button submit
            expect(page).to have_content 'label search test'
          end
        end

        describe "by status and label" do
          before do
            Task.create(title: 'status and label search test', description: 'test description', task_status_id: untouch_id, user_id: test_user.id, label_ids: [label1.id])
            visit root_path
          end
          it 'should show search result with correct task title' do
            select "未着手", from: "task_status_id"
            select label1.name, from: "label_id"
            click_button submit
            expect(page).to have_content 'status and label search test'
          end
        end
      end

      describe 'pagination' do
        describe "with 20 tasks" do
          before do
            create_list(:task, 20, task_status_id: untouch_id, user_id: test_user.id)
            visit root_path
          end
          it 'should not have link to 3rd page' do
            expect(page).not_to have_link '3'
          end
          it 'should match correct titles in 1st page' do
            Task.page(1).per(10).each do |task|
              expect(page).to have_content task.title
            end
          end
          it 'should match correct titles in 2nd page' do
            visit root_path(page: "2")
            Task.page(2).per(10).each do |task|
              expect(page).to have_content task.title
            end
          end
          it 'should not contain any task titles in 3rd page' do
            visit root_path(page: "3")
            Task.all.each do |task|
              expect(page).not_to have_content task.title
            end
          end
        end

        describe "with 21 tasks" do
          before do
            create_list(:task, 21, task_status_id: untouch_id, user_id: test_user.id)
            visit root_path(page: "2")
          end
          it 'should not have link to 4th page' do
            expect(page).not_to have_link '4'
          end
          it 'should match correct titles in 2nd page' do
            Task.page(2).per(10).each do |task|
              expect(page).to have_content task.title
            end
          end
          it 'should match correct title in 3rd page' do
            visit root_path(page: "3")
            Task.page(3).per(10).each do |task|
              expect(page).to have_content task.title
            end
          end
          it 'should not contain any task titles in 4th page' do
            visit root_path(page: "4")
            Task.all.each do |task|
              expect(page).not_to have_content task.title
            end
          end
        end
      end

      describe 'User' do
        let(:test_user2) { create(:test_user2) }
        let!(:new_task) { Task.create(title: 'new task', description: 'new task description',
          task_status_id: task_status_untouch.id, user_id: test_user2.id) }
        before { visit root_path }
        it 'should not viewable other user task in list page' do
          expect(page).not_to have_content 'new task'
        end
        it 'should not viewable other user task detail' do
          get task_path(new_task.id)
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
