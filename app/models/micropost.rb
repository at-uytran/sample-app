class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.model.content_max_len.to_i}
  validate :picture_size
  scope :created_desc, ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.model.picture_size.to_i.megabyte
    errors.add(:picture, I18n.t("model.micropost.picture_size"))
  end
end
