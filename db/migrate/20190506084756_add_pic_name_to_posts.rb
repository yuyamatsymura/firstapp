class AddPicNameToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :pic_name, :string
  end
end
