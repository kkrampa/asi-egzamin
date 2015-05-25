class Contact < ActiveRecord::Base
  validates :email, presence: false, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, :allow_blank => true
  validates :name, presence: false
  validates :phone_number, presence: false
  belongs_to :user
  def self.search(search)
    if search
     self.where("email like ? OR phone_number like ? OR name like ?", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      self.all
    end
  end
end
