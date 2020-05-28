require 'rails_helper'

RSpec.describe Task, type: :model do
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

      context 'title is not blank' do
        let(:search_word) { 'elephant' }
        let(:task) { Task.search_by_title(search_word) }
        it 'search count' do
          expect(task.size).to eq(2)
        end

        it 'search title' do
          expect(task[0].title).to include(search_word)
          expect(task[1].title).to include(search_word)
        end
      end

      context 'title is blank' do
        let(:search_word) { '' }
      end
    end
  end
end
