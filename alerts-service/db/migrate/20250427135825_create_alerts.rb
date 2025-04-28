class CreateAlerts < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :alerts, id: :uuid do |t|
      t.uuid    :rule_id, null: false
      t.integer :car_code, null: false
      t.string  :metric, null: false
      t.decimal :threshold, null: false
      t.string :operator, null: false
      t.decimal :last_value, null: false
      t.string  :severity, null: false

      t.datetime :opened_at, null: false
      t.datetime :last_trigger_at, null: false
      t.datetime :closed_at

      t.timestamps
    end

    add_index :alerts, [:rule_id, :car_code, :opened_at]
    add_index :alerts, :closed_at
  end
end
