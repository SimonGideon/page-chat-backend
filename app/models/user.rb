class User < ApplicationRecord
  before_create :generate_jti
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  private

  def generate_jti
    self.jti ||= SecureRandom.uuid
  end
end
