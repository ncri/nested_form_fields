class Todo < ActiveRecord::Base
  belongs_to :model_with_todos, polymorphic: true
end
