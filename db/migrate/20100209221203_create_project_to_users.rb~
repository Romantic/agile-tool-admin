class CreateProjectToUsers < ActiveRecord::Migration
  def self.up
    create_table :project_to_users, {:force => true} do |t|
      t.belongs_to :project
      t.belongs_to :user
      t.integer :hours, :limit => 1, :default => 8
      t.timestamps
    end

    change_table :users do |t|
      t.integer :hours, :limit => 1, :default => 8
    end
  end

  def self.down
    drop_table :project_to_users
    remove_column :users, :hours
  end
end

