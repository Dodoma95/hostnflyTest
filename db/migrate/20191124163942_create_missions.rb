class CreateMissions < ActiveRecord::Migration[6.0]
  def change
    create_table :missions do |t|
      t.string :mission_type
      t.date :date
      t.integer :price
      t.references :apartment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
