class ChangeProjectDescription < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.change :description, :string, :limit => 1000
    end
  end

  def self.down
    change_table :projects do |t|
      t.change :description, :string
    end  
  end
end
