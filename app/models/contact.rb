class Contact < ActiveRecord::Base
  validates :email, presence: false, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, :allow_blank => true
  validates :name, presence: false
  validates :phone_number, presence: false
  belongs_to :user
end
