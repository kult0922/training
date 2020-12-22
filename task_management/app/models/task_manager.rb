# タスクを管理するクラス
class TaskManager
  # TODO:値が無かった場合のエラーハンドリングを追加する

  # タスクテーブルからユーザーが保有するタスクを取得する
  def self.getUserTasks(user_id)
    user_tbl_one_record = User.select('users_tbl_id').find_by(user_id: user_id)
    user_tbl_id = user_tbl_one_record[0]
    Task.where(user_id: user_tbl_id)
  end
end