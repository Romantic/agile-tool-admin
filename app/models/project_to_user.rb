class ProjectToUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_presence_of :hours
  validates_numericality_of :hours, :only_integer => true, :great_than => 0, :less_than => 24

  class << self
    def unassign(project, user)
      project_to_user = first(:conditions => {:project_id => project.id, :user_id => user.id})
      project_to_user.destroy if project_to_user
      Role.project_roles.each do |role|
        project.accepts_no_role role, user
      end
    end
  end
end

