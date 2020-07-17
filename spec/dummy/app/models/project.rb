class Project < ActiveRecord::Base
  belongs_to :user
  has_many :todos, as: :model_with_todos
  accepts_nested_attributes_for :todos, allow_destroy: true
end
