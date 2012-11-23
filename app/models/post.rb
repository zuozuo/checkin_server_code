class Post < ActiveRecord::Base
  attr_accessible :content, :reward, :title

  belongs_to :user
  has_many :shares
  has_many :feedbacks
  has_many :user_spaces, :through => :shares
end
