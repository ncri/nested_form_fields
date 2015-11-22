class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :description
      t.belongs_to :model_with_todos, polymorphic: true
    end
    add_index :todos, :model_with_todos_id
    add_index :todos, :model_with_todos_type
  end
end
