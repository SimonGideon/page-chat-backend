require "rails_helper"

RSpec.describe User, type: :model do
  describe "callbacks" do
    it "generates a JTI before creation" do
      user = build(:user, jti: nil)
      expect(user.jti).to be_nil
      user.save!
      user.reload
      expect(user.jti).not_to be_nil
    end
  end

  describe "JWT revocation" do
    let(:user) { create(:user) }

    it "revokes JWT if the JTI does not match" do
      payload = { "jti" => SecureRandom.uuid }
      expect(user.send(:jwt_revoked?, payload, user)).to be_truthy
    end

    it "does not revoke JWT if the JTI matches" do
      payload = { "jti" => user.jti }
      expect(user.send(:jwt_revoked?, payload, user)).to be_falsey
    end
  end
end
