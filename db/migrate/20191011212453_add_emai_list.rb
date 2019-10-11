class AddEmaiList < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :email
      t.boolean :ian_confirmed_legit
      t.timestamps
    end
  end
end
