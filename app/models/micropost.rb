class Micropost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  default_scope -> {order(created_at: :desc)}
  mount_uploader :image, ImageUploader
  self.inheritance_column = :_type_disabled # この行を追加
  validates :user_id,presence: true
  validates :denimname,presence: true
  validates :brandname,presence: true
  validates :type,presence: true
  validates :color,presence: true
  validates :image,presence: true
  validates :comment,presence: true

  def self.search(search)
    if search
      where(['denimname LIKE ?',"%#{search}%"])
    else
      all
    end
  end

  def like_user(user_id)
   likes.find_by(user_id: user_id)
  end

end
