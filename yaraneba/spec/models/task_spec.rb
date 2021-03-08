require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'create' do
    context 'validation' do
      it 'success process' do
        task = build(:task)
        expect(task.valid?).to be true
      end

      it 'title nil' do
        task = build(:task, title: nil)
        task.valid?
        expect(task.errors[:title]).to include('を入力してください')
      end

      it 'before scheduled date' do
        expect {
          create(:task, end_date: Time.zone.local(1993, 1, 16).strftime('%Y-%m-%d'))
        }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'state nil' do
        expect {
          create(:task, status: nil)
        }.to raise_error(ActiveRecord::NotNullViolation)
      end

      it 'state out of range' do
        expect {
          create(:task, status: 'others')
        }.to raise_error(ArgumentError)
      end
    end
  end
end
