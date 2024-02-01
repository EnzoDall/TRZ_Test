class AddInfectionFieldsToSurvivors < ActiveRecord::Migration[6.0]
  def change
    add_column :survivors, :is_infected, :boolean, default: false
    add_column :survivors, :infection_reports, :integer, default: 0
  end
end
