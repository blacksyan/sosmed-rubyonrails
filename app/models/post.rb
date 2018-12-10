class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 250 }
  validate  :picture_size

  private

    # validates size of picture
    def picture_size
      if picture.size > 2.megabytes
        errors.add(:picture, 'should be less than 2 MB')
      end
    end
end
