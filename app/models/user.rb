class User < ApplicationRecord
  has_secure_password # 78

  validates :email, presence: true, uniqueness: true # 78
  validates :name, presence: true # 83
end
