require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'create' do
    context 'validation' do
      it 'title null' do
        task = build(:task, title: '')
        task.valid?
        expect(task.errors[:title]).to include(I18n.t('errors.messages.required'))
      end

      it 'date over' do
        expect {
          create(:task, end_date: Time.zone.local(1993, 1, 16).strftime('%Y-%m-%d'))
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
