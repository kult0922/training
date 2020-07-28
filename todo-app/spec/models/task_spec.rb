# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  it 'Validation success ' do
    task = FactoryBot.build(:task, app_user: FactoryBot.build(:app_user))

    expect(task).to be_valid
  end

  it 'Task name should not be empty ' do
    task = FactoryBot.build(:task, app_user: FactoryBot.build(:app_user))
    task.name = ''

    expect(task).not_to be_valid
  end

  it 'Task due_date should not be empty ' do
    task = FactoryBot.build(:task, app_user: FactoryBot.build(:app_user))
    task.due_date = nil

    expect(task).not_to be_valid
  end

  it 'Task status should be 0 to 2 ' do
    task = FactoryBot.build(:task, app_user: FactoryBot.build(:app_user))
    task.status = 3

    expect(task).not_to be_valid
  end

  it 'Search result should filter by status' do
    app_user = FactoryBot.build(:app_user)
    create(:task, app_user: app_user, name: 'task1', created_at: Time.zone.tomorrow, status: Task.statuses[:in_progress])
    @tasks = create_list(:task, 10, app_user: app_user, created_at: Time.zone.yesterday)

    search_form = SearchForm.new({ sort_direction: 'desc' })

    tasks = Task.search_with_condition(search_form, 1)

    expect(tasks.size).to be(10)

    tasks = Task.search_with_condition(search_form, 2)

    expect(tasks.size).to be(1)

    search_form.status = 1
    tasks = Task.search_with_condition(search_form, 1)

    expect(tasks.size).to be(1)

    tasks = Task.search_with_condition(search_form, 2)

    expect(tasks).to be_empty
  end
end
