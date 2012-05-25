class Todo < ActiveRecord::Base
  belongs_to :model_with_todos, polymorphic: true
  attr_accessible :description
end
