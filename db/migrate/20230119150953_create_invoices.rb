class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.text :company
      t.text :debtor
      t.decimal :total_value, :precision => 8, :scale => 2


      t.timestamps
    end
  end
end
