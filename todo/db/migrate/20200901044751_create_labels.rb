class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :color, null: false
      t.string :text

      t.timestamps
    end
  end
end
