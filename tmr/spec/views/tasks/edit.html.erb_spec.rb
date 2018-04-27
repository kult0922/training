require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    FactoryBot.create(:user)
    @task = assign(:task, Task.create!(valid_attributes))
  end

  let(:valid_attributes) {FactoryBot.build(:task_attributes)}

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(@task), "post" do
    end
  end
end