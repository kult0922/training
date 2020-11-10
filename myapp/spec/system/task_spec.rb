require 'rails_helper'
require 'bcrypt'

RSpec.describe 'Task', js: true, type: :system do
  before do
    @user = User.create(name: 'raku', encrypted_password: BCrypt::Password.create('raku'))
    @task1 = Task.create(user: @user, title: 't1')
    @task2 = Task.create(user: @user, title: 't2')
  end

  it 'index' do
    visit_with_basic_auth root_path, username: 'raku', password: 'raku'
    expect(page).to have_content('t1')
    expect(page).to have_content('t2')
  end

  it 'create' do
    visit_with_basic_auth new_task_path, username: 'raku', password: 'raku'
    fill_in 'Title', with: 't3'
    fill_in 'Description', with: 'desc3'
    click_button 'Submit'

    expect(page).to have_content('Task was successfully created.')
  end

  it 'edit' do
    visit_with_basic_auth task_path(@task1), username: 'raku', password: 'raku'
    expect(page).to have_field 'Title', with: 't1'
    expect(page).to have_field 'Description', with: ''

    fill_in 'Description', with: 'desc1'
    click_button 'Submit'

    expect(page).to have_content('Task was successfully updated.')
    expect(page).to have_field 'Description', with: 'desc1'
  end

  it 'delete' do
    visit_with_basic_auth task_path(@task2), username: 'raku', password: 'raku'
    expect(page).to have_field 'Title', with: 't2'

    page.accept_confirm "Are you sure to delete ?" do
      click_button('Delete')
    end

    expect(page).to have_content('Task was successfully destroyed.')
    expect(page).not_to have_content('t2')
  end

end
