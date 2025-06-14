class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :url
      t.boolean :validated

      t.timestamps
    end
  end
end
