class UserForm
  include ActiveModel::Model
  include UsersHelper

  @@role = Rails.configuration.const['role'].values
  @@teams = Team.all.map { |t| t.id }

  attr_accessor :id, :avatar, :name, :email, :phone_number, :team_id, :role, :password, :password_confirmation, :current_user, :created_by_id

  validate :avatar_must_be_valid, if: -> { avatar.present? }

  validates :name, presence: { message: "Name cannot be blank" }
  
  validates :email, presence: { message: "Email cannot be blank" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is invalid" }
  validate :email_must_be_unique

  validates :password, presence: { message: "Password cannot be blank" },
                      length: { minimum: 8, message: "Password must be at least 8 characters" }, if: :password_required?

  validates :password_confirmation, presence: { message: "Password confirmation cannot be blank" }, if: :password_required?
  validates :password, confirmation: { message: "Password and confirmation do not match" }, if: :password_required?

  validates :phone_number,
    length: { maximum: 13, message: "Phone number must be at most 13 digits" },
    format: { with: /\A\d*\z/, message: "Phone number can only contain digits" },
    allow_blank: true

  validates :team_id, presence: { message: "Team must be selected" }, inclusion: { in: @@teams.map(&:to_s), message: "Team is invalid" }, if: :is_supper_admin
  validates :role, presence: { message: "Role must be selected" }, inclusion: { in: @@role.map(&:to_s), message: "Role is invalid" }, if: :is_supper_admin

  def password_required?
    unless id.present?
      return true
    end
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

  def email_must_be_unique
    existing_users = id.present? ? User.where.not(id: id) : User.all

    if existing_users.exists?(email: email)
      errors.add(:email, "Email already exists")
    end
  end

end
