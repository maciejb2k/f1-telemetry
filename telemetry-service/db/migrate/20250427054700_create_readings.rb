class CreateReadings < ActiveRecord::Migration[7.2]
  def change
    create_table :readings, id: :uuid do |t|
      t.references :car, null: false, type: :uuid, foreign_key: true

      t.string  :metric, null: false
      t.decimal :value,  null: false

      t.timestamps
    end

    add_index :readings, [:metric, :value]
  end
end
