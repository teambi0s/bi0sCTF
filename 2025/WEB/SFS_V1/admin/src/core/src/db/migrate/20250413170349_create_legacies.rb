class CreateLegacies < ActiveRecord::Migration[8.0]
  def change
    create_table :legacies do |t|
      t.string :legacy_secret

      t.timestamps
    end
  end
end
