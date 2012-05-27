class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.belongs_to :user
    end
    add_index :projects, :user_id
  end
end
