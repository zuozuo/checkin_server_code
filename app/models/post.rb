class Post < ActiveRecord::Base
  attr_accessible :content, :reward, :title

  belongs_to :user
end
