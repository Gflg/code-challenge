class AddDefaultValueToIsActiveField < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :is_active, false
  end
end
