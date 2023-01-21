class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.text :confirmed_token
      t.text :token_to_be_confirmed
      t.boolean :is_active

      t.timestamps
    end
  end
end
