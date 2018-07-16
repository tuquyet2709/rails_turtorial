class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.maximum.max_micropost_length}
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.minimum.min_picture_size.megabytes
    errors.add(:picture, I18n.t("microposts.should_be_less_than",
      size: Settings.minimum.min_picture_size))
  end
end
