class ChangeProjectDatesFormat < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.change :start_date, :date
      t.change :end_date, :date
    end
  end

  def self.down
    change_table :projects do |t|
      t.change :start_date, :datetime
      t.change :end_date, :datetime
    end
  end
end
