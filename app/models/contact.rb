class Contact < ActiveRecord::Base
  validates :email, presence: false, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  belongs_to :user
end
