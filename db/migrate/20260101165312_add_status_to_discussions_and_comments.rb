class AddStatusToDiscussionsAndComments < ActiveRecord::Migration[7.1]
  def change
    add_column :discussions, :status, :integer, default: 0
    add_column :comments, :status, :integer, default: 0
  end
end
