require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#validation' do
    describe 'タスク名' do
      context '0文字の場合' do
        let(:task) {FactoryBot.build(:task, task_name: '')}
        it 'バリデーションエラーが発生する' do
          expect(task.validate).to be_falsy
          expect(task.errors).to have_key(:task_name)
          expect(task.errors.full_messages).to eq ['タスク名を入力してください。']
        end
      end

      context '1文字の場合' do
        let(:task) {FactoryBot.build(:task, task_name: 'a')}
        it 'バリデーションエラーが発生しない' do
          expect(task.validate).to be_truthy
        end
      end

      context '255文字の場合' do
        let(:task) {FactoryBot.build(:task, task_name: 'a'*255)}
        it 'バリデーションエラーが発生しない' do
          expect(task.validate).to be_truthy
        end
      end

      context '256文字の場合' do
        let(:task) {FactoryBot.build(:task, task_name: 'a'*256)}
        it 'バリデーションエラーが発生する' do
          expect(task.validate).to be_falsy
          expect(task.errors).to have_key(:task_name)
          expect(task.errors.full_messages).to eq ['タスク名は255字以内で入力してください。']
        end
      end
    end
    
    describe '期限' do
      context '入力しない場合' do
        let(:task) {FactoryBot.build(:task, due_date: '')}
        it 'バリデーションエラーが発生しない' do
          expect(task.validate).to be_truthy
        end
      end

      context '存在しない日付の場合' do
        let(:task) {FactoryBot.build(:task, due_date: '2018-06-31')}
        it 'バリデーションエラーが発生する' do
          expect(task.validate).to be_falsy
          expect(task.errors).to have_key(:due_date)
          expect(task.errors.full_messages).to eq ['期限を正しく入力してください。']
        end
      end
    end

    describe '複数のエラー' do
      context 'タスク名が0文字かつ期限が存在しない日付の場合' do
        let(:task) {FactoryBot.build(:task, task_name: '', due_date: '2018-06-31')}
        it 'バリデーションエラーが複数発生する' do
          expect(task.validate).to be_falsy
          expect(task.errors).to have_key(:task_name)
          expect(task.errors).to have_key(:due_date)
          expect(task.errors.full_messages).to eq ['タスク名を入力してください。', '期限を正しく入力してください。']
        end
      end
    end

    describe 'ステータス' do
      context '2の場合' do
        let(:task) {FactoryBot.build(:task, status: 2)}
        it 'バリデーションエラーが発生しない' do
          expect(task.validate).to be_truthy
        end
      end

      context '3の場合' do
        it '引数エラーが発生する' do
          expect{(FactoryBot.build(:task, status: 3))}.to raise_error(ArgumentError)
        end
      end

      context "'todo'の場合" do
        let(:task) {FactoryBot.build(:task, status: 'todo')}
        it 'バリデーションエラーが発生しない' do
          expect(task.validate).to be_truthy
        end
      end

      context "'todo'、'doing'、'done'以外の場合" do
        it '引数エラーが発生する' do
          expect{(FactoryBot.build(:task, status: 'a'))}.to raise_error(ArgumentError)
        end
      end

      context '空の場合' do
        let(:task) {FactoryBot.build(:task, status: '')}
        it 'バリデーションエラーが発生する' do
          expect(task.validate).to be_falsy
          expect(task.errors).to have_key(:status)
          expect(task.errors.full_messages).to eq ['状態を入力してください。']
        end
      end
    end

    describe '優先度' do
      context '2の場合' do
        let(:task) {FactoryBot.build(:task, priority: 2)}
        it 'バリデーションエラーが発生しない' do
          expect(task.validate).to be_truthy
        end
      end

      context '3の場合' do
        it '引数エラーが発生する' do
          expect{(FactoryBot.build(:task, priority: 3))}.to raise_error(ArgumentError)
        end
      end

      context "'low'の場合" do
        let(:task) {FactoryBot.build(:task, priority: 'low')}
        it 'バリデーションエラーが発生しない' do
          expect(task.validate).to be_truthy
        end
      end

      context "'low'、'middle'、'high'以外の場合" do
        it '引数エラーが発生する' do
          expect{(FactoryBot.build(:task, priority: 'b'))}.to raise_error(ArgumentError)
        end
      end

      context '空の場合' do
        let(:task) {FactoryBot.build(:task, priority: '')}
        it 'バリデーションエラーが発生する' do
          expect(task.validate).to be_falsy
          expect(task.errors).to have_key(:priority)
          expect(task.errors.full_messages).to eq ['優先度を入力してください。']
        end
      end
    end
  end

  describe '#search' do
    before do
      FactoryBot.create(:task, task_name: 'a1', status: 'todo')
      FactoryBot.create(:task, task_name: 'a2', status: 'doing')
      FactoryBot.create(:task, task_name: 'a3', status: 'done')
      FactoryBot.create(:task, task_name: 'b', status: 'todo')
    end

    context 'キーワードなし、ステータス選択なしの場合' do
      it 'タスクを全件取得する' do
        expect(Task.search({searched_task_name: ''}).size).to eq 4
      end
    end

    context 'キーワードなし、未着手のみ選択した場合' do
      it '未着手のタスクを全件取得する' do
        expect(Task.search({searched_task_name: '', statuses: ['todo']}).size).to eq 2
      end
    end

    context 'レコードが存在するタスク名を入力して、ステータス選択なしの場合' do
      it '検索したワードのタスクを全件取得する' do
        expect(Task.search({searched_task_name: 'a'}).size).to eq 3
      end
    end

    context 'レコードが存在するタスク名を入力して、未着手、着手中、完了を選択した場合' do
      it '検索したワードのタスクを全件取得する' do
        expect(Task.search({searched_task_name: 'a', statuses: ['todo', 'doing', 'done']}).size).to eq 3
      end
    end

    context '未着手しか登録されていないレコードのタスク名を入力して、未着手のみ選択した場合' do
      it '検索したワードのタスクから、未着手のタスクのみ取得する' do
        expect(Task.search({searched_task_name: 'b', statuses: ['todo']}).size).to eq 1
      end
    end

    context '未着手しか登録されていないレコードのタスク名を入力して、着手中のみ選択した場合' do
      it '検索結果が0件' do
        expect(Task.search({searched_task_name: 'b', statuses: ['doing']}).size).to eq 0
      end
    end

    context 'レコードが存在しないタスク名を入力して、ステータス選択なしの場合' do
      it '検索結果が0件' do
        expect(Task.search({searched_task_name: 'c'}).size).to eq 0
      end
    end
  end
end