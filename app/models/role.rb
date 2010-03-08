# == Schema Information
# Schema version: 20091206172603
#
# Table name: roles
#
#  id                :integer         not null, primary key
#  name              :string(40)
#  authorizable_type :string(40)
#  authorizable_id   :integer
#  created_at        :datetime
#  updated_at        :datetime
#

# Defines named roles for users that may be applied to
# objects in a polymorphic fashion. For example, you could create a role
# "moderator" for an instance of a model (i.e., an object), a model class,
# or without any specification at all.
class Role < ActiveRecord::Base
  ADMIN = "admin"
  FRONT_USER = "front_user"
  DEVELOPER = "developer"
  SCRUM_MASTER = "scrum_master"
  SPECTATOR = "spectator"
  
  OBJECT_ROLES = [DEVELOPER, SCRUM_MASTER, SPECTATOR]

  has_many :roles_users, :dependent => :delete_all
  has_many :users, :through => :roles_users
  belongs_to :authorizable, :polymorphic => true
  
  class << self
  
    # Gets array of roles that can be assigned to project.
    def project_roles
      [DEVELOPER, SCRUM_MASTER, SPECTATOR]
    end
  
  end
end
