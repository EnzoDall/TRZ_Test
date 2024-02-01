class CreateSurvivors < ActiveRecord::Migration[6.0]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.float :latitude
      t.float :longitude
      t.boolean :infected, default: false

      t.timestamps
    end
  end
end

class AddInfectionReportsToSurvivors < ActiveRecord::Migration[6.0]
  def change
    add_column :survivors, :infection_reports, :integer, default: 0
  end
end
