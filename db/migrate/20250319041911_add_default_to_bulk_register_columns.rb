class AddDefaultToBulkRegisterColumns < ActiveRecord::Migration[8.0]
  def change
    change_column_default :bulk_registers, :total_lines, 0
    change_column_default :bulk_registers, :lines_read, 0
    change_column_default :bulk_registers, :success_count, 0
  end
end
