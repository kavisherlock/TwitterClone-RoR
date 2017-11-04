class CreateTweats < ActiveRecord::Migration[5.1]
  def change
    create_table :tweats do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :tweats, [:user_id, :created_at]
  end
end
