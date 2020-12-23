# タスクを管理するクラス
class TaskManager
  # TODO:テーブルに値が無かった場合のエラーハンドリングを追加する

  # タスクテーブルからユーザーが保有するタスクを全件取得する
  def self.getUserTasks(user_id)
    user_id_ary = User.select('id').find_by(user_id: user_id)
    user_tbl_id = user_id_ary.id
    Task.where(user_id: user_tbl_id)
  end
end