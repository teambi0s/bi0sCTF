class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :isolated
      t.boolean :random
      t.boolean :extension
      t.string :file_path

      t.timestamps
    end
  end
end
