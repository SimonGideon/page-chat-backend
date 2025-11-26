class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :favorites, dependent: :destroy
  before_create :generate_jti
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, :membership_number, :first_name, :last_name,
            :phone, :address, :country, :gender, :nationality,
            :city, :date_of_birth, presence: true

  validates :email, :membership_number, :jti, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum status: {
    active: "active",
    disabled: "disabled",
    suspended: "suspended",
    inactive: "inactive"
  }, _suffix: true

  before_destroy :prevent_destroy

  has_many :favorite_books, through: :favorites, source: :book

  private

  def jwt_revoked?(payload, user)
    !user.present? || user.jti != payload["jti"]
  end

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end

  def prevent_destroy
    errors.add(:base, "Users cannot be deleted. Update their status instead.")
    throw :abort
  end

  # set password to be phone number if password is empty
  def password_required?
    super && phone.present?
  end
end
