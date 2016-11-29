class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.integer :status, null: false
      t.string :description, null: false
      t.references :customer, foreign_key: true, index: true, null: false
      t.references :agent, foreign_key: true, index: true

      t.timestamps
    end
  end
end
