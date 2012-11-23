class Feedback < ActiveRecord::Base
  attr_accessible :comment, :share_id

  belongs_to :post
  belongs_to :user_space
end
