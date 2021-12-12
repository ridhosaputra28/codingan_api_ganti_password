class TambahEmailTakTerkonfirmasiKepadaUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_tak_terkonfirmasi, :string
  end
end
