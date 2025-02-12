class CreateJoinTableUsersRoles < ActiveRecord::Migration[8.0]
  def change
    create_join_table :users, :roles, column_options: { type: :uuid } do |t|
      t.index :user_id
      t.index :role_id
    end
  end
end
