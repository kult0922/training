class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name
      t.string :code
    end
    add_index :labels, :code, unique: true
  end
end
