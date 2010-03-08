# == Schema Information
# Schema version: 20091206172603
#
# Table name: users
#
#  id                :integer         not null, primary key
#  email             :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  first_name        :string(255)
#  last_name         :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_authorized_user
  acts_as_authorizable

  has_many :roles_users, :dependent => :delete_all

  def full_name
    "#{last_name}, #{first_name}"
  end

  validates_presence_of :hours
  validates_numericality_of :hours, :only_integer => true, :great_than => 0, :less_than => 24

  class << self
    def by_role_id(role_id, order_by = "last_name ASC")
      find_by_sql ["SELECT * FROM users WHERE id in (SELECT user_id FROM roles_users WHERE role_id  = ?) order by #{order_by}", role_id]
    end

    def by_role(role_name, order_by = "last_name ASC")
      find_by_sql ["SELECT * FROM users WHERE id in (SELECT user_id FROM roles_users WHERE role_id in (SELECT id FROM roles WHERE name = ?)) order by #{order_by}", role_name]
    end

    def front_users(order_by = "last_name ASC")
      by_role Role::FRONT_USER, order_by
    end

    def admins(order_by = "last_name ASC")
      by_role Role::ADMIN, order_by
    end

    def by_project(project_id, order_by = "last_name ASC")
      find_by_sql ["SELECT * FROM users WHERE id in (SELECT user_id FROM project_to_users WHERE project_id = ?) order by #{order_by}", project_id]
    end

    def not_in_project(project_id, order_by = "last_name ASC")
      find_by_sql ["SELECT * FROM users WHERE id not in (SELECT user_id FROM project_to_users WHERE project_id = ?) order by #{order_by}", project_id]
    end
  end
end

