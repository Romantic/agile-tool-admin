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

require File.dirname(__FILE__) + '/../spec_helper'

describe Project do
  it "should be valid" do
    Project.new.should be_valid
  end
end
