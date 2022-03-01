class AddCatImage < ActiveRecord::Migration[6.1]
  def change
    create_table :cat_images do |t|
      t.string :name
      # t.attachment :avatar
      t.timestamps
    end
  end
end
