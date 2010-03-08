class GenerateUsers < ActiveRecord::Migration
  def self.up
    admin = User.new(
      :email => "admin@gmail.com",
      :first_name => "John",
      :last_name => "Black",
      :password => "qqqqqq",
      :password_confirmation => "qqqqqq"
    )
    admin.save(false)
    admin.has_role Role::ADMIN

    front_user = User.new(
      :email => "a.white@gmail.com",
      :first_name => "Alex",
      :last_name => "White",
      :password => "qqqqqq",
      :password_confirmation => "qqqqqq"
    )
    front_user.save(false)
    front_user.has_role Role::FRONT_USER

    front_user = User.new(
      :email => "t.green@gmail.com",
      :first_name => "Tom",
      :last_name => "Green",
      :password => "qqqqqq",
      :password_confirmation => "qqqqqq"
    )
    front_user.save(false)
    front_user.has_role Role::FRONT_USER

    front_user = User.new(
      :email => "d.red@gmail.com",
      :first_name => "David",
      :last_name => "Red",
      :password => "qqqqqq",
      :password_confirmation => "qqqqqq"
    )
    front_user.save(false)
    front_user.has_role Role::FRONT_USER
  end

  def self.down
    User.delete_all
  end
end

