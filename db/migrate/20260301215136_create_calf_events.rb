class CreateCalfEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :calf_events do |t|
      t.references :calf, null: false, foreign_key: true
      t.integer :event_type, null: false, default: 0
      t.text :description, null: false
      t.datetime :occurred_at, null: false

      t.integer :status_from
      t.integer :status_to
      t.decimal :weight_lbs, precision: 6, scale: 2
      t.string :medication_name
      t.string :dose
      t.string :route

      t.timestamps
    end

    add_index :calf_events, [:calf_id, :occurred_at]
    add_index :calf_events, :event_type
  end
end
