class User < ActiveRecord::Base
  has_many :projects
  attr_accessible :name, :projects_attributes
  accepts_nested_attributes_for :projects, allow_destroy: true
end
