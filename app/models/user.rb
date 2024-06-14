class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  before_create :generate_jti

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, :membership_number, :first_name, :last_name,
            :phone, :home_church, :residence, :city,
            :date_of_birth, presence: true

  validates :email, :membership_number, :jti, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def jwt_revoked?(payload, user)
    !user.present? || user.jti != payload["jti"]
  end

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end
end
