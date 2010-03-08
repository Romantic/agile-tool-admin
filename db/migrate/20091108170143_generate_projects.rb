class GenerateProjects < ActiveRecord::Migration
  def self.up
    Project.delete_all
    
    (1..100).each do
      date_range = Time.random_range
      Project.create(
        :name => Forgery(:lorem_ipsum).words(3, {:random => true}),
        :description => Forgery(:lorem_ipsum).paragraphs(3, {:random => true}),
        :start_date => date_range[0],
        :end_date => date_range[1]
      )
    end
  end

  def self.down
    Project.delete_all
  end
end
