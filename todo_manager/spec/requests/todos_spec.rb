require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  let!(:todo) { create(:todo) }
  let!(:user) { todo.user }
  subject { page }

  shared_examples_for 'have a header' do
    describe 'header of normal user' do
      it 'should have a header with todo list link and logout link without admin link' do
        is_expected.to have_link(I18n.t('title'), href: '/')
        is_expected.not_to have_link(I18n.t('dictionary.management'), href: '/admin')
        is_expected.to have_link(I18n.t('dictionary.logout'), href: '/logout')
      end
    end
  end

  describe 'Home (index) page' do
    before { visit '/' }
    context 'before login' do

      it 'should show a flash' do
        is_expected.to have_content(I18n.t('flash.users.login.must'))
      end

      it 'should be login page' do
        expect(current_path).to eq '/login'
      end

      it 'should have a header and the login link and the signup link' do
        is_expected.to have_link(I18n.t('title'), href: '/login')
        is_expected.to have_link(I18n.t('dictionary.signup'), href: '/signup')
        is_expected.to have_link(I18n.t('dictionary.login'), href: '/login')
      end

      describe 'signup' do
        before { click_link I18n.t('dictionary.signup') }

        it 'should be signup page' do
          expect(current_path).to eq '/signup'
        end

        context 'same name already exists' do
          before do
            fill_in 'name', with: user.name
            fill_in 'password', with: 'hoge'
            click_button I18n.t('dictionary.signup')
          end

          it "can't be created and show error messages" do
            expect(current_path).to eq '/users/create'
            is_expected.to have_content(I18n.t('errors.format', attribute: User.human_attribute_name(:name), message: I18n.t('errors.messages.taken')))
          end
        end

        context 'name is nil' do
          before do
            fill_in 'password', with: 'hoge'
            click_button I18n.t('dictionary.signup')
          end

          it "can't be created and show error messages" do
            expect(current_path).to eq '/users/create'
            is_expected.to have_content(I18n.t('errors.format', attribute: User.human_attribute_name(:name), message: I18n.t('errors.messages.empty')))
          end
        end

        context 'password is nil' do
          before do
            fill_in 'name', with: 'name'
            click_button I18n.t('dictionary.signup')
          end

          it "can't be created and show error messages" do
            expect(current_path).to eq '/users/create'
            is_expected.to have_content(I18n.t('errors.format', attribute: User.human_attribute_name(:password), message: I18n.t('errors.messages.empty')))
          end
        end

        context 'unique name' do
          before do
            fill_in 'name', with: 'unique'
            fill_in 'password', with: 'password'
            click_button I18n.t('dictionary.signup')
          end

          it 'can be created' do
            expect(current_path).to eq '/'
            is_expected.to have_content(I18n.t('flash.users.signup'))
          end

          it_behaves_like 'have a header'
        end
      end

      describe 'login' do
        context 'name is wrong' do
          before do
            fill_in 'name', with: 'aaaa'
            fill_in 'password', with: user.password
            click_button I18n.t('dictionary.login')
          end

          it "can't be logged in" do
            is_expected.to have_content(I18n.t('flash.users.login.failure'))
            expect(current_path).to eq '/login'
          end
        end

        context 'password is wrong' do
          before do
            fill_in 'name', with: user.name
            fill_in 'password', with: 'aaaa'
            click_button I18n.t('dictionary.login')
          end

          it "can't be logged in" do
            is_expected.to have_content(I18n.t('flash.users.login.failure'))
            expect(current_path).to eq '/login'
          end
        end

        context 'name and password are true' do
          context 'normal user' do
            before do
              fill_in 'name', with: user.name
              fill_in 'password', with: user.password
              click_button I18n.t('dictionary.login')
            end

            it 'can be logged in' do
              is_expected.to have_content(I18n.t('flash.users.login.success'))
              expect(current_path).to eq '/'
            end

            it_behaves_like 'have a header'
          end

          context 'admin user' do
            let!(:admin) { create(:user, name: 'admin_user', password: 'pass', user_type: 'admin') }
            before do
              fill_in 'name', with: admin.name
              fill_in 'password', with: 'pass'
              click_button I18n.t('dictionary.login')
            end

            it 'can be logged in' do
              is_expected.to have_content(I18n.t('flash.users.login.success'))
              expect(current_path).to eq '/'
            end

            it 'should have a header with admin link' do
              is_expected.to have_link(I18n.t('title'), href: '/')

              is_expected.to have_link(I18n.t('dictionary.management'), href: '/admin')

              is_expected.to have_link(I18n.t('dictionary.logout'), href: '/logout')
            end

            describe 'admin' do
              before { click_link I18n.t('dictionary.management') }
              it 'should show user lists' do
                is_expected.to have_content(I18n.t('views.admin.index.title'))
              end

              it 'should have the create link' do
                is_expected.to have_link(I18n.t('dictionary.create'), href: '/admin/new')
              end

              it 'should show ID, name, role and No. of todos' do
                theads = page.first('thead tr')
                expect(theads).to have_content('ID')
                expect(theads).to have_content(I18n.t('dictionary.name'))
                expect(theads).to have_content(I18n.t('dictionary.role'))
                expect(theads).to have_content(I18n.t('dictionary.number_of_tasks'))
              end

              it 'should have users' do
                tbodies = page.all('tbody tr')
                expect(tbodies[0]).to have_content(user.id)
                expect(tbodies[0]).to have_content(user.name)
                expect(tbodies[0]).to have_content(I18n.t("role.#{user.user_type}"))
                expect(tbodies[0]).to have_content(user.todos.count)
                expect(tbodies[1]).to have_content(admin.id)
                expect(tbodies[1]).to have_content(admin.name)
                expect(tbodies[1]).to have_content(I18n.t("role.#{admin.user_type}"))
                expect(tbodies[1]).to have_content(admin.todos.count)
              end

              describe 'show user' do
                before { click_link user.name }

                it 'should show user profile' do
                  expect(current_path).to eq "/admin/#{user.id}"
                  is_expected.to have_link(I18n.t('dictionary.edit'), href: "/admin/#{user.id}/edit")
                  is_expected.to have_button(I18n.t('dictionary.destroy'))
                end

                describe 'edit user' do
                  before { click_link I18n.t('dictionary.edit') }

                  it { expect(current_path).to eq "/admin/#{user.id}/edit" }
                end

                describe 'destroy user', js: true do
                  context 'accept' do
                    before do
                      page.accept_confirm I18n.t('flash.confirmation.delete') do
                        click_button I18n.t('dictionary.destroy')
                      end
                    end

                    it 'should delete user and show success notice and user list page' do
                      is_expected.to have_content(I18n.t('flash.users.destroy.success'))
                      expect(current_path).to eq '/admin'
                      is_expected.not_to have_content(user.name)
                    end
                  end

                  context 'dismiss' do
                    before do
                      page.dismiss_confirm I18n.t('flash.confirmation.delete') do
                        click_button I18n.t('dictionary.destroy')
                      end
                    end

                    it { expect(current_path).to eq "/admin/#{user.id}" }
                  end
                end
              end

              describe 'show todos' do
                before { click_on user.todos.count }

                it "should be user's todo list page" do
                  expect(current_path).to eq "/admin/#{user.id}/todos"
                  tbodies = page.first('tbody tr')
                  expect(tbodies).to have_content(user.todos.first.title)
                  expect(tbodies).to have_content(user.todos.first.content)
                end

                context 'show todo profile page' do
                  before { click_on user.todos.first.title }

                  it { expect(current_path).to eq "/todos/#{user.todos.first.id}/detail" }
                end

                describe "create user's todos" do
                  before do
                    click_on I18n.t('dictionary.create')
                    fill_in 'title', with: "user's todo"
                    fill_in 'content', with: "user's content"
                    select I18n.t('priority.high'), from: 'todo[priority_id]'
                    fill_in 'labels[x1][name]', with: "user's label"
                    fill_in 'deadline', with: Time.zone.parse('2099-08-01 12:00')
                    click_on I18n.t('dictionary.create')
                  end

                  it { is_expected.to have_content(I18n.t('flash.todos.create')) }

                  it 'should create todos' do
                    is_expected.to have_content("user's todo")
                    is_expected.to have_content("user's content")
                    is_expected.to have_content(I18n.t('priority.high'))
                    is_expected.to have_link("user's label")
                    is_expected.to have_content(I18n.l(Time.zone.parse('2099-08-01 12:00'), format: :long))
                  end
                end
              end

              describe 'create user' do
                before do
                  click_link I18n.t('dictionary.create')
                  fill_in 'name', with: 'hogehoge'
                  fill_in 'password', with: 'fugafuga'
                end

                it 'should show create user page' do
                  is_expected.to have_content(I18n.t('views.admin.new.title'))
                end

                it 'should create new user' do
                  click_button I18n.t('dictionary.create')
                  is_expected.to have_content(I18n.t('flash.users.create'))
                  is_expected.to have_content('hogehoge')
                end
              end
            end
          end
        end
      end
    end

    context 'after login' do
      before do
        visit '/login'
        fill_in 'name', with: user.name
        fill_in 'password', with: user.password
        click_button I18n.t('dictionary.login')
      end

      it "should show the 'Todo List' page" do
        is_expected.to have_content(I18n.t('views.todos.index.title'))
      end

      describe 'log out' do
        before do
          click_on I18n.t('dictionary.logout')
        end

        it 'should be logged out' do
          is_expected.to have_content(I18n.t('flash.users.logout'))
          expect(current_path).to eq '/login'
        end
      end

      it 'should show only the todo created by oneself' do
        is_expected.to have_content(todo.title)
        is_expected.to have_content(todo.content)
        is_expected.to have_content(I18n.t("priority.#{todo.priority_id}"))
        is_expected.to have_content(I18n.t("status.#{todo.status_id}"))
        is_expected.to have_content(I18n.l(todo.deadline, format: :long))
        another_user = create(:user, name: 'another')
        another_todo = create(:todo, title: 'another_todo', user_id: another_user.id)
        is_expected.not_to have_content(another_todo.title)
      end

      it 'should show the todo ordered by created_at as desc' do
        create(:todo, title: 'test1', content: 'one', user_id: user.id, created_at: 1.hours.since, updated_at: 1.hours.since)
        create(:todo, title: 'test2', content: 'two', user_id: user.id, created_at: 2.hours.since, updated_at: 2.hours.since)
        create(:todo, title: 'test3', content: 'three', user_id: user.id, created_at: 3.hours.since, updated_at: 3.hours.since)
        visit '/'
        trs = page.all('tbody tr')
        expect(trs[0]).to have_content('three')
        expect(trs[1]).to have_content('two')
        expect(trs[2]).to have_content('one')
      end

      describe 'sort todos by deadline' do
        let!(:todo2) { create(:todo, title: 'hoge', user_id: user.id, status_id: 1, deadline: 2.days.since) }
        let!(:todo3) { create(:todo, title: 'hoge', user_id: user.id, status_id: 1, deadline: 3.days.since) }
        before { click_link I18n.t('dictionary.deadline') }
        context 'in asc' do
          it 'should be ordered' do
            trs = page.all('tbody tr')
            expect(trs[0]).to have_content(I18n.l(todo.deadline, format: :long))
            expect(trs[1]).to have_content(I18n.l(todo2.deadline, format: :long))
            expect(trs[2]).to have_content(I18n.l(todo3.deadline, format: :long))
          end

          it 'should be refined by status_id' do
            click_button(I18n.t('status.working'))
            trs = page.all('tbody tr')
            expect(trs[0]).to have_content(I18n.l(todo2.deadline, format: :long))
            expect(trs[1]).to have_content(I18n.l(todo3.deadline, format: :long))
          end

          it 'should be refined by title' do
            fill_in 'search', with: 'hoge'
            click_button(I18n.t('dictionary.search'))
            trs = page.all('tbody tr')
            expect(trs[0]).to have_content(I18n.l(todo2.deadline, format: :long))
            expect(trs[1]).to have_content(I18n.l(todo3.deadline, format: :long))
          end
        end

        context 'in desc' do
          before { click_link I18n.t('dictionary.deadline') }

          it 'should be ordered' do
            trs = page.all('tbody tr')
            expect(trs[0]).to have_content(I18n.l(todo3.deadline, format: :long))
            expect(trs[1]).to have_content(I18n.l(todo2.deadline, format: :long))
            expect(trs[2]).to have_content(I18n.l(todo.deadline, format: :long))
          end

          it 'should be refined by status_id' do
            click_button(I18n.t('status.working'))
            trs = page.all('tbody tr')
            expect(trs).to all(have_content(I18n.t('status.working')))
            expect(trs[0]).to have_content(I18n.l(todo3.deadline, format: :long))
            expect(trs[1]).to have_content(I18n.l(todo2.deadline, format: :long))
          end

          it 'should be refined by title' do
            fill_in 'search', with: 'hoge'
            click_button(I18n.t('dictionary.search'))
            trs = page.all('tbody tr')
            expect(trs).to all(have_content('hoge'))
            expect(trs[0]).to have_content(I18n.l(todo3.deadline, format: :long))
            expect(trs[1]).to have_content(I18n.l(todo2.deadline, format: :long))
          end
        end
      end

      describe 'sort todos by priority' do
        before do
          create(:todo, title: 'hoge', user_id: user.id, priority_id: 0, status_id: 1)
          create(:todo, title: 'hoge', user_id: user.id, priority_id: 2, status_id: 1)
          click_link I18n.t('dictionary.priority')
        end
        context 'in asc' do
          it 'should be ordered' do
            trs = page.all('tbody tr')
            expect(trs[0]).to have_content(I18n.t('priority.low'))
            expect(trs[1]).to have_content(I18n.t('priority.middle'))
            expect(trs[2]).to have_content(I18n.t('priority.high'))
          end

          it 'should be refined by status_id' do
            click_button(I18n.t('status.working'))
            trs = page.all('tbody tr')
            expect(trs).to all(have_content(I18n.t('status.working')))
            expect(trs[0]).to have_content(I18n.t('priority.low'))
            expect(trs[1]).to have_content(I18n.t('priority.high'))
          end

          it 'should be refined by title' do
            fill_in 'search', with: 'hoge'
            click_on(I18n.t('dictionary.search'))
            trs = page.all('tbody tr')
            expect(trs).to all(have_content('hoge'))
            expect(trs[0]).to have_content(I18n.t('priority.low'))
            expect(trs[1]).to have_content(I18n.t('priority.high'))
          end
        end

        context 'in desc' do
          before { click_on I18n.t('dictionary.priority') }

          it 'should be ordered' do
            trs = page.all('tbody tr')
            expect(trs[0]).to have_content(I18n.t('priority.high'))
            expect(trs[1]).to have_content(I18n.t('priority.middle'))
            expect(trs[2]).to have_content(I18n.t('priority.low'))
          end

          it 'should be refined by status_id' do
            click_on(I18n.t('status.working'))
            trs = page.all('tbody tr')
            expect(trs).to all(have_content(I18n.t('status.working')))
            expect(trs[0]).to have_content(I18n.t('priority.high'))
            expect(trs[1]).to have_content(I18n.t('priority.low'))
          end

          it 'should be refined by title' do
            fill_in 'search', with: 'hoge'
            click_on(I18n.t('dictionary.search'))
            trs = page.all('tbody tr')
            expect(trs.count).to eq 2
            expect(trs).to all(have_content('hoge'))
            expect(trs[0]).to have_content(I18n.t('priority.high'))
            expect(trs[1]).to have_content(I18n.t('priority.low'))
          end
        end
      end

      describe 'refine search' do
        context 'with status_id' do
          before do
            create(:todo, user_id: user.id, status_id: 1)
            create(:todo, user_id: user.id, status_id: 2)
          end

          it 'can be refined by status_id: 0' do
            click_on I18n.t('status.unstarted')
            trs = page.all('tbody tr')
            expect(trs).to all(have_content(I18n.t('status.unstarted')))
          end

          it 'can be refined by status_id: 1' do
            click_on I18n.t('status.working')
            trs = page.all('tbody tr')
            expect(trs).to all(have_content(I18n.t('status.working')))
          end

          it 'can be refined by status_id: 2' do
            click_on I18n.t('status.completed')
            trs = page.all('tbody tr')
            expect(trs).to all(have_content(I18n.t('status.completed')))
          end

          it 'shows all status when clicking all' do
            click_on I18n.t('dictionary.all')
            trs = page.all('tr')
            expect(trs.count).to eq 4
          end
        end

        context 'with title' do
          it 'can be refined by title' do
            create(:todo, user_id: user.id, title: 'hoge')
            create(:todo, user_id: user.id, title: 'fuga')
            fill_in 'search', with: 'hoge'
            click_on I18n.t('dictionary.search')
            trs = page.all('tbody tr')
            expect(trs).to all(have_content('hoge'))
          end
        end

        context 'with both status_id and title' do
          before do
            create(:todo, user_id: user.id, title: 'hoge', status_id: 0)
            create(:todo, user_id: user.id, title: 'fuga', status_id: 0)
            create(:todo, user_id: user.id, title: 'hoge', status_id: 1)
            create(:todo, user_id: user.id, title: 'fuga', status_id: 1)
            create(:todo, user_id: user.id, title: 'hoge', status_id: 2)
            create(:todo, user_id: user.id, title: 'fuga', status_id: 2)
            fill_in 'search', with: 'hoge'
            click_on I18n.t('dictionary.search')
          end

          describe 'refined by status_id and title' do
            context 'status_id: 0' do
              before { click_on I18n.t('status.unstarted') }
              let(:trs) { page.all('tbody tr') }
              it do
                expect(trs).to all(have_content('hoge'))
                expect(trs).to all(have_content(I18n.t('status.unstarted')))
              end
            end

            context 'status_id: 1' do
              before { click_on I18n.t('status.working') }
              let(:trs) { page.all('tbody tr') }
              it do
                expect(trs).to all(have_content('hoge'))
                expect(trs).to all(have_content(I18n.t('status.working')))
              end
            end

            context 'status_id: 2' do
              before { click_on I18n.t('status.completed') }
              let(:trs) { page.all('tbody tr') }
              it do
                expect(trs).to all(have_content('hoge'))
                expect(trs).to all(have_content(I18n.t('status.completed')))
              end
            end
          end
        end
      end

      it 'should have the create link' do
        is_expected.to have_link(I18n.t('dictionary.create'), href: '/todos/new')
      end

      describe 'create todos page' do
        before { click_on I18n.t('dictionary.create') }

        it_behaves_like 'have a header'

        it "should have the word 'Create Todo'" do
          is_expected.to have_content(I18n.t('views.todos.new.title'))
        end

        it 'should have the select box for the priority' do
          is_expected.to have_select('todo[priority_id]', options: I18n.t('priority').values)
        end

        it 'should have the 3 input box for labels' do
          3.times do |i|
            is_expected.to have_field("labels[x#{i + 1}][name]", with: '')
          end
        end

        describe 'create new todo' do
          context 'title is nil' do
            before do
              fill_in 'content', with: 'fuga'
              select I18n.t('priority.low'), from: 'todo[priority_id]'
              fill_in 'labels[x1][name]', with: 'test_label'
              fill_in 'deadline', with: '2099-08-01T12:00'
              click_on I18n.t('dictionary.create')
            end

            it 'should back to the create page' do
              expect(current_path).to eq '/todos/create'
            end

            it 'should show an error message' do
              is_expected.to have_content(I18n.t('errors.format', attribute: Todo.human_attribute_name(:title), message: I18n.t('errors.messages.blank')))
            end

            it 'should keep the value' do
              is_expected.to have_field('content', with: 'fuga')
              is_expected.to have_select('todo[priority_id]', selected: I18n.t('priority.low'))
              is_expected.to have_field('labels[x1][name]', with: 'test_label')
              is_expected.to have_field('deadline', with: '2099-08-01T12:00')
            end
          end

          context 'title is not nil' do
            before do
              fill_in 'title', with: 'hoge'
              fill_in 'content', with: 'fuga'
              select I18n.t('priority.low'), from: 'todo[priority_id]'
              fill_in 'labels[x1][name]', with: 'test_label'
              fill_in 'deadline', with: Time.zone.parse('2099-08-01 12:00')
              click_on I18n.t('dictionary.create')
            end

            it_behaves_like 'have a header'

            it 'should be index page after creating' do
              expect(current_path).to eq '/'
            end

            it 'should show a flash message' do
              is_expected.to have_content(I18n.t('flash.todos.create'))
            end

            it 'should show the created todo' do
              is_expected.to have_link('hoge')
              is_expected.to have_content('fuga')
              is_expected.to have_content(I18n.t('priority.low'))
              is_expected.to have_link('test_label')
              is_expected.to have_content(I18n.l(Time.zone.parse('2099-08-01 12:00'), format: :long))
            end

            it 'should show the label in todo detail page' do
              click_on 'hoge'
              is_expected.to have_content('test_label')
            end

            describe 'refine search with labels' do
              before { click_on 'test_label' }

              it { is_expected.to have_content('hoge') }
              it { is_expected.not_to have_content(todo.title) }
            end

            describe 'detail page' do
              before { click_on todo.title }

              it_behaves_like 'have a header'

              it 'should have the value' do
                is_expected.to have_content(todo.title)
                is_expected.to have_content(todo.content)
                is_expected.to have_content(I18n.t('priority.middle'))
                is_expected.to have_content(I18n.t('status.unstarted'))
                is_expected.to have_content(I18n.l(todo.deadline, format: :long))
              end

              it 'should have the link' do
                is_expected.to have_link(I18n.t('dictionary.edit'))
                is_expected.to have_link(I18n.t('dictionary.destroy'))
              end

              describe 'edit page' do
                before { click_on I18n.t('dictionary.edit') }

                it_behaves_like 'have a header'

                it "should have the content 'Edit Todo', title and content of the todo" do
                  is_expected.to have_content(I18n.t('views.todos.edit.title'))
                end

                it 'should have the value' do
                  is_expected.to have_field('title', with: todo.title)
                  is_expected.to have_field('content', with: todo.content)
                  is_expected.to have_select('todo[priority_id]', selected: I18n.t("priority.#{todo.priority_id}"))
                  is_expected.to have_select('todo[status_id]', selected: I18n.t("status.#{todo.status_id}"))
                  3.times do |i|
                    is_expected.to have_field("labels[x#{i + 1}][name]", with: '')
                  end
                  is_expected.to have_field('deadline', with: todo.deadline.strftime('%Y-%m-%dT%H:%M'))
                end

                describe 'update the todo' do
                  context 'title is nil' do
                    before do
                      fill_in 'title', with: ''
                      fill_in 'content', with: 'Edited content'
                      select I18n.t('priority.low'), from: 'todo[priority_id]'
                      select I18n.t('status.completed'), from: 'todo[status_id]'
                      fill_in 'labels[x1][name]', with: 'nice_label'
                      fill_in 'deadline', with: '2099-08-01T12:00'
                      click_on I18n.t('dictionary.update')
                    end

                    it_behaves_like 'have a header'

                    it 'should back to the edit page' do
                      is_expected.to have_content(I18n.t('views.todos.edit.title'))
                    end

                    it 'should show an error message' do
                      is_expected.to have_content(I18n.t('errors.format', attribute: Todo.human_attribute_name(:title), message: I18n.t('errors.messages.blank')))
                    end

                    it 'should keep the edited value' do
                      is_expected.to have_field('content', with: 'Edited content')
                      is_expected.to have_select('todo[priority_id]', selected: I18n.t('priority.low'))
                      is_expected.to have_select('todo[status_id]', selected: I18n.t('status.completed'))
                      is_expected.to have_field('labels[x1][name]', with: 'nice_label')
                      is_expected.to have_field('deadline', with: '2099-08-01T12:00')
                    end
                  end

                  context 'title is not nil' do
                    before do
                      fill_in 'title', with: 'Edited title'
                      fill_in 'content', with: 'Edited content'
                      select I18n.t('priority.low'), from: 'todo[priority_id]'
                      select I18n.t('status.completed'), from: 'todo[status_id]'
                      fill_in 'labels[x1][name]', with: 'nice_label'
                      fill_in 'deadline', with: Time.zone.parse('2099-08-01 12:00')
                      click_on I18n.t('dictionary.update')
                    end

                    it_behaves_like 'have a header'

                    it 'should be detail page after updating todo' do
                      expect(current_path).to eq "/todos/#{todo.id}/detail"
                    end

                    it 'should show the updated content' do
                      is_expected.to have_content('Edited title')
                      is_expected.to have_content('Edited content')
                      is_expected.to have_content(I18n.t('priority.low'))
                      is_expected.to have_content(I18n.t('status.completed'))
                      is_expected.to have_content('nice_label')
                      is_expected.to have_content(I18n.l(Time.zone.parse('2099/08/01 12:00'), format: :long))
                    end

                    it 'should show a flash message' do
                      is_expected.to have_content(I18n.t('flash.todos.update'))
                    end

                    describe 'labels' do
                      before { click_on I18n.t('dictionary.edit') }
                      context 'update' do
                        before do
                          fill_in "labels[#{Label.find_by(name: 'nice_label').id}][name]", with: 'great_label'
                          click_on I18n.t('dictionary.update')
                        end

                        it { is_expected.to have_content('great_label') }
                        it { is_expected.not_to have_content('nice_label') }
                      end

                      context 'delete' do
                        before do
                          fill_in "labels[#{Label.find_by(name: 'nice_label').id}][name]", with: ''
                          click_on I18n.t('dictionary.update')
                        end

                        it { is_expected.not_to have_content('nice_label') }
                      end
                    end
                  end
                end
              end

              describe 'destroy action' do
                before { click_on I18n.t('dictionary.destroy') }

                it 'should be index page after deleting todo' do
                  expect(current_path).to eq '/'
                end

                it 'should delete todo' do
                  is_expected.to_not have_link(todo.title)
                  is_expected.to_not have_content(todo.content)
                end

                it 'should show a flash message' do
                  is_expected.to have_content(I18n.t('flash.todos.destroy.success'))
                end
              end
            end
          end
        end
      end
    end
  end
end