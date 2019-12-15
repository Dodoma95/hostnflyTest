class CreateApartment < ActiveRecord::Migration[6.0]
  def change
    create_table :apartments do |t|
      t.integer :num_rooms

      t.timestamps
    end
  end
end
