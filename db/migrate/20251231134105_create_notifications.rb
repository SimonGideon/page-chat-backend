class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      # Who receives the notification
      t.uuid :recipient_id, null: false

      # Who triggered the action
      t.uuid :actor_id, null: false

      # Action type: liked, commented, replied
      t.string :action, null: false

      # Polymorphic reference (Comment, Discussion, etc.)
      t.string :notifiable_type, null: false
      t.uuid   :notifiable_id, null: false

      # Read / unread state
      t.datetime :read_at

      t.timestamps
    end

    # Indexes for performance
    add_index :notifications, :recipient_id
    add_index :notifications, :actor_id
    add_index :notifications, :read_at
    add_index :notifications, [:notifiable_type, :notifiable_id]
    add_index :notifications, [:recipient_id, :read_at]

    # Foreign keys
    add_foreign_key :notifications, :users, column: :recipient_id
    add_foreign_key :notifications, :users, column: :actor_id
  end
end
