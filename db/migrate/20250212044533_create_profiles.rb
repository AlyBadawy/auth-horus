class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
