class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.references  :user,  index: true, foreign_key: true
      t.string :name, null: false, limit: 10

      t.timestamps
    end
  end
end
