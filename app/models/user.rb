class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :favorites, dependent: :destroy
  before_create :generate_jti
  has_one_attached :avatar
  has_many :discussions, dependent: :destroy

  has_many :reading_positions, dependent: :destroy
  has_many :currently_reading_books, through: :reading_positions, source: :book


  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification",
           foreign_key: :actor_id,
           dependent: :nullify


  belongs_to :country, foreign_key: :country_code, primary_key: :code, optional: true
  belongs_to :city, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, :first_name, :last_name,
            :phone, :address, :gender,
            :date_of_birth, presence: true
  validates :country_code, :city_id, presence: true

  validates :email, :jti, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def active_for_authentication?
    super && confirmed?
  end

  def inactive_message
    if !confirmed?
      :unconfirmed
    else
      super
    end
  end

  enum status: {
    active: "active",
    disabled: "disabled",
    suspended: "suspended",
    inactive: "inactive"
  }, _suffix: true

  before_destroy :prevent_destroy

  has_many :favorite_books, through: :favorites, source: :book

  def avatar_url
    return nil unless avatar.attached?
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: false)
  end

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

  def password_required?
    return false if new_record?
    return true if reset_password_token.present?
    super && phone.present?
  end
end
