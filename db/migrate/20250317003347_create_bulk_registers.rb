class CreateBulkRegisters < ActiveRecord::Migration[8.0]
  def change
    create_table :bulk_registers do |t|
      t.integer :total_lines
      t.integer :lines_read
      t.integer :success_count
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
