class AddSpeechViolationRatingToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :speech_violation_rating, :integer, default: 0
  end
end
