require "rails_helper"

RSpec.describe Api::V1::Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in successfully" do
        user = create(:user, email: "test@example.com", password: "password", password_confirmation: "password")
        post :create, params: { user: { email: "test@example.com", password: "password" } }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["code"]).to eq(200)
        expect(json_response["status"]["message"]).to eq("Logged in successfully.")
        expect(json_response["data"]).not_to be_nil
        expect(json_response["data"]["email"]).to eq("test@example.com")
      end
    end
  end

  describe "DELETE #destroy" do
    context "when not logged in" do
      it "returns unauthorized" do
        delete :destroy

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["code"]).to eq(401)
        expect(json_response["status"]["message"]).to eq("Couldn't find an active session.")
      end
    end
  end
end
