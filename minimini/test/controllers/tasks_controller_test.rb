require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
  end

  teardown do
    # コントローラがキャッシュを使っている場合、テスト後にリセットしておくとよい
    Rails.cache.clear
  end
  
  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_task_url
    assert_response :success
  end

  test "should create task" do
    post tasks_url, params: { task: {　name: "タスク名1", description: "タスク内容1", status: "未着手", labels: "1", user_id: "9999", due_date: "2022-01-01" } }
    assert_equal 'タスク名1', @task.name
    assert_equal 'タスク内容1', @task.description
    assert_response :success
  end

  test "should show task" do
    get task_url(@task)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_url(@task)
    assert_response :success
  end

  test "should update task" do
    patch task_url(@task), params: { task: {　id: @task.id, name: "[updated]タスク名1", description: "[updated]タスク内容1", status: "完了", labels: "D: 緊急度低", due_date: "2023-01-01" } }
    assert_redirected_to task_path(@task)

    @task.reload
    assert_equal '[updated]タスク名1', @task.name
    assert_equal '[updated]タスク内容1', @task.description
    assert_equal '完了', @task.status
    assert_equal 'D: 緊急度低', @task.labels
    assert_equal '2023-01-01', @task.due_date.strftime('%Y-%m-%d')
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end
end
