# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it 'タスク名と優先順位が設定されていれば有効' do
    task = Task.new(title: 'title', priority: 1, user: user)
    expect(task).to be_valid
  end

  it 'タスク名が設定されていなければ無効' do
    task = Task.new(priority: 1, user: user)
    task.valid?
    expect(task.errors[:title]).to include('入力がありません')
  end

  it '優先順位が設定されていなければ無効' do
    task = Task.new(title: 'title', user: user)
    task.valid?
    expect(task.errors[:priority]).to include('入力がありません')
  end

  it 'タスク名が30文字までなら有効' do
    task = Task.new(title: 'ああああああああああいいいいいいいいいいうううううううううう', priority: 1, user: user)
    expect(task).to be_valid
  end

  it 'タスク名が30文字を超えると無効' do
    task = Task.new(title: 'ああああああああああいいいいいいいいいいううううううううううえ', priority: 1, user: user)
    task.valid?
    expect(task.errors[:title]).to include('文字列が長すぎます')
  end

  it '優先順位が0以下の場合は無効' do
    task = Task.new(title: 'title', priority: 0, user: user)
    task.valid?
    expect(task.errors[:priority]).to include('0より大きな数値を入力してください')
  end

  it '優先順位が数値以外の場合は無効' do
    task = Task.new(title: 'title', priority: 'abc', user: user)
    task.valid?
    expect(task.errors[:priority]).to include('数値ではありません')
  end

  it '優先順位が同じユーザーで重複している場合は無効' do
    Task.create(
      title: 'First task',
      description: 'Submit documents',
      priority: 1,
      user: user)
    task = Task.new(title: 'title', priority: 1, user: user)
    task.valid?
    expect(task.errors[:priority]).to include('値が重複しています')
  end

  it '優先順位が異なるユーザーで重複している場合は有効' do
    Task.create(
      title: 'First task',
      description: 'Submit documents',
      priority: 1,
      user: user)
    task = Task.new(title: 'title', priority: 1, user: FactoryBot.create(:user))
    expect(task).to be_valid
  end

  it '新規作成したタスクはステータスが未着手になる' do
    task = Task.new(title: 'title', priority: 1, user: user)
    expect(task).to have_state(:ready)
  end

  it '未着手のタスクを着手するとステータスが着手になる' do
    task = Task.new(title: 'title', priority: 1, aasm_state: :ready, user: user)
    task.start!
    expect(task).to have_state(:doing)
  end

  it '着手中のタスクを完了するとステータスが完了になる' do
    task = Task.new(title: 'title', priority: 1, aasm_state: :doing, user: user)
    task.complete!
    expect(task).to have_state(:done)
  end

  it '未着手のタスクを完了しようとするとエラー' do
    task = Task.new(title: 'title', priority: 1, aasm_state: :ready, user: user)
    expect { task.complete! }.to raise_error(AASM::InvalidTransition)
  end

  it '着手中のタスクを着手しようとするとエラー' do
    task = Task.new(title: 'title', priority: 1, aasm_state: :doing, user: user)
    expect { task.start! }.to raise_error(AASM::InvalidTransition)
  end

  it '完了したタスクを着手しようとするとエラー' do
    task = Task.new(title: 'title', priority: 1, aasm_state: :done, user: user)
    expect { task.start! }.to raise_error(AASM::InvalidTransition)
  end

  it '完了したタスクを完了しようとするとエラー' do
    task = Task.new(title: 'title', priority: 1, aasm_state: :done, user: user)
    expect { task.complete! }.to raise_error(AASM::InvalidTransition)
  end
end
