class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_one_attached :group_image

  validates :name, presence: true


  def get_groups_image
    (group_image.attached?) ? group_image : "no-image-icon.jpg"
  end
end
