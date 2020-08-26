class InsertInitialTaskStatus < ActiveRecord::Migration[6.0]
  def change
    statuses = {"未着手"=>"誰も手を付けていない", "着手中"=>"対応中", "完了"=>"対応完了"}
    statuses.each do |key, value|
      TaskStatus.create(name: key, description: value)
    end
  end
end
