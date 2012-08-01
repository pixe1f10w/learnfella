# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Post < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }

  default_scope order: 'posts.created_at DESC'

  def self.from_users_followed_by user
    followed_user_ids = "select followed_id from relationships where follower_id = :user_id"
    where "user_id in ( #{followed_user_ids} ) or user_id = :user_id", user_id: user
  end
end

