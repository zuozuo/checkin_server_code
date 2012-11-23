class Share < ActiveRecord::Base
  attr_accessible :post_id, :user_space_id

  belongs_to :post
  belongs_to :user_space
end
