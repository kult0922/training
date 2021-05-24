# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'タスク名と優先順位が設定されていれば有効' do
    task = Task.new(title: 'title', priority: 1)
    expect(task).to be_valid
  end

  it 'タスク名が設定されていなければ無効' do
    task = Task.new(priority: 1)
    task.valid?
    expect(task.errors[:title]).to include('入力がありません')
  end

  it '優先順位が設定されていなければ無効' do
    task = Task.new(title: 'title')
    task.valid?
    expect(task.errors[:priority]).to include('入力がありません')
  end

  it 'タスク名が30文字までなら有効' do
    task = Task.new(title: 'ああああああああああいいいいいいいいいいうううううううううう', priority: 1)
    expect(task).to be_valid
  end

  it 'タスク名が30文字を超えると無効' do
    task = Task.new(title: 'ああああああああああいいいいいいいいいいううううううううううえ', priority: 1)
    task.valid?
    expect(task.errors[:title]).to include('文字列が長すぎます')
  end

  it '優先順位が0以下の場合は無効' do
    task = Task.new(title: 'title', priority: 0)
    task.valid?
    expect(task.errors[:priority]).to include('0より大きな数値を入力してください')
  end

  it '優先順位が数値以外の場合は無効' do
    task = Task.new(title: 'title', priority: 'abc')
    task.valid?
    expect(task.errors[:priority]).to include('数値ではありません')
  end

  it '優先順位が重複している場合は無効' do
    Task.create(
      title: 'First task',
      description: 'Submit documents',
      priority: 1)
    task = Task.new(title: 'title', priority: 1)
    task.valid?
    expect(task.errors[:priority]).to include('値が重複しています')
  end
end
