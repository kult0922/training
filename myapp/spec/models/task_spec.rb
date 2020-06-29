require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'title column' do
    context 'when title is null' do
      let(:task) { build(:task, title: '') }
      it 'raise not null validation massage' do
        task.valid?
        expect(task.errors[:title]).to include('を入力してください')
      end
    end

    context 'when title is 21 or more' do
      let(:task) { build(:task, title: 'a' * 21) }
      it 'raise length validation message' do
        task.valid?
        expect(task.errors[:title]).to include('は20文字以内で入力してください')
      end
    end
  end

  describe 'Association' do
    let(:association) { Task.reflect_on_association(terget) }
    context 'when checking user association' do
      let(:terget) { :user }
      it 'return belongs_to association' do
        expect(association.macro).to eq :belongs_to
      end
    end
  end

  describe 'search' do
    let!(:task1) { create(:task, title: 'hoge', status: 'not_start') }
    let!(:task2) { create(:task, title: 'huga', status: 'underway') }
    let!(:task3) { create(:task, title: 'gau', status: 'done') }

    context 'when searching by title' do
      it 'return search result only for title' do
        expect(Task.search('hoge', nil, nil)).to eq([task1])
      end
    end

    context 'when searching by status' do
      it 'return search result only for status' do
        expect(Task.search(nil, 'underway', nil)).to eq([task2])
      end
    end

    context 'when searching by title and status' do
      it 'return search result for title, status' do
        expect(Task.search('gau', 'done', nil)).to eq([task3])
      end
    end
  end
end
