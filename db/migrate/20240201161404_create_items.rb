class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :points
      t.references :survivor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
