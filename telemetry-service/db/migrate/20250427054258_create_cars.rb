class CreateCars < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :cars, id: :uuid do |t|
      t.integer :car_code, null: false, index: { unique: true }
      t.string  :driver
      t.string  :chassis, default: "RB21"
      t.string :team_name
      t.string :driver_photo_url

      t.timestamps
    end
  end
end
