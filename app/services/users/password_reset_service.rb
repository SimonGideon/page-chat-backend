module Users
  class PasswordResetService
    def self.call(user)
      new(user).call
    end

    def initialize(user)
      @user = user
    end

    def call
      new_password = SecureRandom.base58(12)
      user.update!(password: new_password, password_confirmation: new_password)
      UserMailer.password_reset_notification(user, new_password).deliver_later
      new_password
    end

    private

    attr_reader :user
  end
end

