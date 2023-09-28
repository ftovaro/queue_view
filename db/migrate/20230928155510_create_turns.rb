class CreateTurns < ActiveRecord::Migration[7.0]
  def change
    create_table :turns do |t|
      t.integer :status, default: 0
      t.integer :value, default: 0

      t.timestamps
    end
  end
end
