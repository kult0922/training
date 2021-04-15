class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.datetime :deleted_at, limit: 6

      t.timestamps
    end
  end
end
