class AddRecommendedToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :recommended, :boolean, default: false
  end
end
