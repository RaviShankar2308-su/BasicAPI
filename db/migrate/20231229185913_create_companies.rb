class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
