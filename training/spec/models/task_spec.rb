require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    describe 'title' do
      subject { FactoryBot.build(:task, title: title) }
      context 'valid' do
        context 'title is 49 characters' do
          let(:title) { 'a' * 49 }
          it { is_expected.to be_valid }
        end

        context 'title is 50 characters' do
          let(:title) { 'a' * 50 }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'title is blank' do
          let(:title) { '' }
          it { is_expected.to be_invalid }
          it 'display enter message' do
            subject.save
            expect(subject.errors[:title][0]).to eq I18n.t('errors.messages.blank')
          end
        end
        context 'title is 51 characters' do
          let(:title) { 'a' * 51 }
          it { is_expected.to be_invalid }
          it 'display to long message' do
            subject.save
            expect(subject.errors[:title][0]).to eq I18n.t('errors.messages.too_long', count: 50)
          end
        end
      end
    end

    describe 'priority' do
      subject { FactoryBot.build(:task, priority: priority) }
      context 'valid' do
        context 'priority is present' do
          let(:priority) { 'low' }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'priority is blank' do
          let(:priority) { '' }
          it { is_expected.to be_invalid }
          it 'display enter message' do
            subject.save
            expect(subject.errors[:priority][0]).to eq I18n.t('errors.messages.blank')
          end
        end
      end
    end

    describe 'status' do
      subject { FactoryBot.build(:task, status: status) }
      context 'valid' do
        context 'status is present' do
          let(:status) { 'waiting' }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'status is blank' do
          let(:status) { '' }
          it { is_expected.to be_invalid }
          it 'display enter message' do
            subject.save
            expect(subject.errors[:status][0]).to eq I18n.t('errors.messages.blank')
          end
        end
      end
    end

    describe 'due_date' do
      subject { FactoryBot.build(:task, due_date: due_date) }
      context 'valid' do
        context 'due_date is blank' do
          let(:due_date) { '' }
          it { is_expected.to be_valid }
        end

        context 'due_date is future' do
          let(:due_date) { Time.now + 1.day }
          it { is_expected.to be_valid }
        end
      end

      context 'invalid' do
        context 'due_date is past' do
          let(:due_date) { Time.now - 1.day }
          it { is_expected.to be_invalid }
          it 'display enter future date message' do
            subject.save
            expect(subject.errors[:due_date][0]).to eq I18n.t('errors.messages.due_date_is_past')
          end
        end
      end
    end
  end

  describe 'search' do
    describe 'order_by_due_date' do
      before do
        FactoryBot.create_list(:task, 5, :with_order_by_due_date)
      end
      let(:task_order_by_due_date) { Task.order_by_due_date(order_type) }
      let(:task_regular_order) { Task.order(due_date: order_type) }
      context 'asc' do
        let(:order_type) { :asc }
        it 'order by asc' do
          expect(task_order_by_due_date).to eq(task_regular_order)
        end
      end

      context 'desc' do
        let(:order_type) { :desc }
        it 'order by asc' do
          expect(task_order_by_due_date).to eq(task_regular_order)
        end
      end
    end

    describe 'search_by_title' do
      before do
        FactoryBot.create(:task, title: 'tiger elephant gorilla')
        FactoryBot.create(:task, title: 'rabbit rat')
        FactoryBot.create(:task, title: 'bear elephant')
        FactoryBot.create(:task, title: 'monkey')
        FactoryBot.create(:task, title: 'zebra deer')
      end

      let(:task) { Task.search_by_title(search_word) }
      context 'title is present' do
        let(:search_word) { 'elephant' }
        it 'is 2 records' do
          expect(task.size).to eq(2)
        end

        it 'include search record' do
          expect(task[0].title).to include(search_word)
          expect(task[1].title).to include(search_word)
        end
      end

      context 'title is blank' do
        let(:search_word) { '' }
        it 'is 5 records' do
          expect(task.size).to eq(5)
        end
      end
    end

    describe 'search_by_status' do
      before do
        FactoryBot.create(:task, status: 'waiting')
        FactoryBot.create(:task, status: 'working')
        FactoryBot.create(:task, status: 'done')
        FactoryBot.create(:task, status: 'waiting')
        FactoryBot.create(:task, status: 'done')
      end

      let(:task) { Task.search_by_status(status) }
      context 'status is present' do
        let(:status) { 'done' }
        it 'is 2 records' do
          expect(task.size).to eq(2)
        end

        it 'include search record' do
          expect(task[0].status).to eq('done')
          expect(task[1].status).to eq('done')
        end
      end

      context 'status is blank' do
        let(:status) { '' }
        it 'all records' do
          expect(task.size).to eq(5)
        end
      end
    end

    describe 'search_by_label' do
      let(:label_function_addition) { FactoryBot.create(:label_function_addition) }
      let(:label_infrastructure) { FactoryBot.create(:label_infrastructure) }
      let(:label_system_issue) { FactoryBot.create(:label_system_issue) }
      let(:label_refactoring) { FactoryBot.create(:label_refactoring) }
      let(:tasks) { FactoryBot.create_list(:task, 5) }

      before do
        tasks[0].labels << label_function_addition
        tasks[1].labels << label_function_addition
        tasks[2].labels << label_infrastructure
        tasks[3].labels << label_refactoring
        tasks[4].labels << label_infrastructure
      end

      let(:search_tasks) { Task.search_by_label(label_function_addition.id) }
      context 'status is present' do
        let(:status) { 'done' }
        it 'is 2 records' do
          expect(search_tasks.size).to eq(2)
        end

        it 'include search record' do
          expect(search_tasks[0].labels[0].code).to eq('function_addition')
          expect(search_tasks[1].labels[0].code).to eq('function_addition')
        end
      end

      context 'status is blank' do
        let(:status) { '' }
        it 'all records' do
          expect(tasks.size).to eq(5)
        end
      end
    end
  end
end
