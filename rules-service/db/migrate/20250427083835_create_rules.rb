class CreateRules < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :rules, id: :uuid do |t|
      t.string :metric, null: false
      t.string :operator, null: false
      t.decimal :threshold, null: false
      t.string :severity, null: false
      t.integer :car_scope
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :rules, [:metric, :car_scope]
  end
end
