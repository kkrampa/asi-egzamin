class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :email
      t.string :password
      t.integer :device
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
