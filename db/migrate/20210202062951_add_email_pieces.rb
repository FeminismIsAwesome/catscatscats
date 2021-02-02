class AddEmailPieces < ActiveRecord::Migration[6.0]
  def change
    add_column :emails, :name, :string
    add_column :emails, :playtester, :boolean, default: false
    add_column :emails, :notes, :text
  end
end
