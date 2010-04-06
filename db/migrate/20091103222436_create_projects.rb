class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :description, :limit => 1000
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end
  end
  
  def self.down
    drop_table :projects
  end
end
