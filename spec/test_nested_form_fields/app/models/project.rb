class Project < ActiveRecord::Base
  belongs_to :user
  has_many :todos, as: :model_with_todos
  attr_accessible :description, :name, :todos_attributes
  accepts_nested_attributes_for :todos, allow_destroy: true
end
