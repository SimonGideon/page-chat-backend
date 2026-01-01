class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports, id: :uuid do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :reportable, polymorphic: true, null: false, type: :uuid
      t.string :reason

      t.timestamps
    end
  end
end
