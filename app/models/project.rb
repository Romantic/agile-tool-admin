# == Schema Information
# Schema version: 20091206172603
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(1000)
#  start_date  :date
#  end_date    :date
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base

  acts_as_authorizable

  has_many :roles, :as => :authorizable

  def start_date_string
      I18n.l(start_date, :format => :date_picker) if start_date
  end

  def start_date_string=(value)
      start_date = Date.strptime(value, I18n.t("date.formats.date_picker")) if value
  end

  def end_date_string
      I18n.l(end_date, :format => :date_picker) if end_date
  end

  def end_date_string=(value)
      end_date = Date.strptime(value, I18n.t("date.formats.date_picker")) if value
  end

  validates_presence_of :name
  validates_length_of :name, :within => 3..50, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true

  validates_length_of :description, :maximum => 1000

  validate :start_date_could_exceed_end_date

  def start_date_could_exceed_end_date
      if start_date && end_date
          errors.add(:start_date, :should_not_exceed_end_date) if start_date > end_date
      end
  end
end

