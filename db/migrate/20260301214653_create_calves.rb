class CreateCalves < ActiveRecord::Migration[7.1]
  def change
    create_table :calves do |t|
      t.string  :name, null: false
      t.date    :birthdate
      t.decimal :weight_lbs, precision: 6, scale: 2
      t.integer :status, null: false, default: 0
      t.text    :medications
      t.text    :notes

      t.timestamps
    end

    add_index :calves, :name
    add_index :calves, :status
  end
end
