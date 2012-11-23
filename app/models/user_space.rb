class UserSpace < ActiveRecord::Base
  attr_accessible :name, :social, :types, :user_id, :share_id

  belongs_to :user
  has_many :shares
  has_many :feedbacks
  has_many :posts, :through => :shares
end
