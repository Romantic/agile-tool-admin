class ProjectToUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_presence_of :hours
  validates_numericality_of :hours, :only_integer => true, :great_than => 0, :less_than => 24
end

