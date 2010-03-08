# == Schema Information
# Schema version: 20091206172603
#
# Table name: roles_users
#
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

# The table that links roles with users (generally named RoleUser.rb)
class RolesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  class << self

    def project_roles(project_id)
      all(:joins => [:role], :conditions => ["roles.authorizable_id = ?", project_id])
    end
  end
end

