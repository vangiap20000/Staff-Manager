class ProfileForm
  include ActiveModel::Model
  include UsersHelper

  attr_accessor :id, :avatar, :name, :phone_number, :password, :password_confirmation, :created_by_id

  validate :avatar_must_be_valid, if: -> { avatar.present? }

  validates :name, presence: { message: "Name cannot be blank" }
  
  validates :password, presence: { message: "Password cannot be blank" },
                      length: { minimum: 8, message: "Password must be at least 8 characters" }, if: :password_required?

  validates :password_confirmation, presence: { message: "Password confirmation cannot be blank" }, if: :password_required?
  validates :password, confirmation: { message: "Password and confirmation do not match" }, if: :password_required?

  validates :phone_number,
    length: { maximum: 13, message: "Phone number must be at most 13 digits" },
    format: { with: /\A\d*\z/, message: "Phone number can only contain digits" },
    allow_blank: true


  def password_required?
    password.present? || password_confirmation.present?
  end

  def avatar_must_be_valid
    acceptable_types = ["image/jpeg", "image/png", "image/gif", "image/webp"]
    unless acceptable_types.include?(avatar.content_type)
      errors.add(:avatar, "Must be an image file (jpg, png, gif, webp)")
    end

    max_size_in_bytes = 5.megabytes
    if avatar.size > max_size_in_bytes
      errors.add(:avatar, "File must not be larger than 5MB")
    end
  end
end
