class AddAvatarToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :avatar, :string
  end
end
