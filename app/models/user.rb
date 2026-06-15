class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Trestle::Auth::ModelMethods::Rememberable
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
         :confirmable, :omniauthable, :jwt_authenticatable,
         jwt_revocation_strategy: self,
         omniauth_providers: [:google_oauth2]

  # Skip profile validations for OAuth users — they signed in with Google
  # and haven't filled in phone/address/etc yet.
  validates :email, :first_name, :last_name,
            :phone, :address, :gender,
            :date_of_birth, presence: true, unless: :oauth_user?
  validates :country_code, :city_id, presence: true, unless: :oauth_user?

  # ── Google OAuth ────────────────────────────────────────────────────────────
  # Called by the OmniAuth callback controller after Google confirms the user.
  # auth is an OmniAuth::AuthHash that looks like:
  #   auth.provider  => "google_oauth2"
  #   auth.uid       => "109876543210"  (Google's unique ID for this person)
  #   auth.info.email        => "simon@gmail.com"
  #   auth.info.first_name   => "Simon"
  #   auth.info.last_name    => "Gideon"
  #   auth.info.image        => "https://lh3.googleusercontent.com/..."
  def self.from_omniauth(auth)
    # Try to find an existing user by Google's uid first,
    # then fall back to email (in case they already have a normal account)
    user = find_by(provider: auth.provider, uid: auth.uid) ||
           find_by(email: auth.info.email)

    if user
      # Existing user — attach Google credentials if not already set
      user.update_columns(
        provider: auth.provider,
        uid:      auth.uid
      ) if user.uid.blank?
      return user
    end

    # Brand-new user — create with whatever Google gave us
    create!(
      provider:   auth.provider,
      uid:        auth.uid,
      email:      auth.info.email,
      first_name: auth.info.first_name || auth.info.name.split.first,
      last_name:  auth.info.last_name  || auth.info.name.split.last,
      password:   SecureRandom.hex(16),   # random password — they use Google to log in
      confirmed_at: Time.current,          # auto-confirm — Google already verified the email
      jti:        SecureRandom.uuid
    )
  end

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

  enum role: { user: 0, admin: 1 }

  before_destroy :prevent_destroy

  has_many :favorite_books, through: :favorites, source: :book

  def avatar_url
    return nil unless avatar.attached?
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: false)
  end

  after_update :send_activation_email, if: -> { saved_change_to_confirmed_at? && confirmed_at.present? }
  
  def increment_violation_rating!
    increment!(:speech_violation_rating)
    if speech_violation_rating >= 60 && !suspended_status?
      suspended_status!
    end
  end

  private

  def send_activation_email
    UserMailer.account_activated(self).deliver_later
  end

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
    # OAuth users don't set a password through the normal flow
    return false if oauth_user?
    return false if new_record?
    return true if reset_password_token.present?
    super && phone.present?
  end

  def oauth_user?
    provider.present?
  end
end
