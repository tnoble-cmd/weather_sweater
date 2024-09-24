class User < ApplicationRecord
  has_secure_password

  before_create :generate_api_key

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  private

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end