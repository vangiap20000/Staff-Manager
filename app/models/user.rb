class User < ApplicationRecord
  has_secure_password
  belongs_to :team
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id', optional: true
  has_one_attached :avatar 
end