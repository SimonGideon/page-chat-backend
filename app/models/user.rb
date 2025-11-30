class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :favorites, dependent: :destroy
  before_create :generate_jti
  has_one_attached :avatar

  belongs_to :country, foreign_key: :country_code, primary_key: :code, optional: true
  belongs_to :city, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, :first_name, :last_name,
            :phone, :address, :gender,
            :date_of_birth, presence: true
  validates :country_code, :city_id, presence: true

  validates :email, :jti, uniqueness: true
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
