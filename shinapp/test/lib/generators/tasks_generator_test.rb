require 'test_helper'
require 'generators/tasks/tasks_generator'

class TasksGeneratorTest < Rails::Generators::TestCase
  tests TasksGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
