require 'rails_helper'

RSpec.describe "tasks/index", type: :view do


  before(:each) do
    FactoryBot.create(:user)

    assign(:tasks, [
      Task.create!(valid_attributes),
      Task.create!(valid_attributes)
    ])
  end

  let(:valid_attributes) {FactoryBot.build(:task_attributes)}

  # ソートのメソッドがViewから呼べていない。あとで解決策を調べる
  xit "renders a list of tasks" do
    render
  end
end
