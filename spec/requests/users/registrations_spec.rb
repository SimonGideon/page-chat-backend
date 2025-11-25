require "rails_helper"

RSpec.describe Api::V1::Users::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers # Include this module

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new user" do
        user_attributes = attributes_for(:user)

        expect {
          post :create, params: { user: user_attributes }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["code"]).to eq(200)
        expect(json_response["status"]["message"]).to eq("Signed up sucessfully.")
        expect(json_response["data"]).not_to be_nil
        expect(json_response["data"]["email"]).to eq(user_attributes[:email])
      end
    end

    context "with invalid params" do
      it "does not create a new user" do
        user_attributes = attributes_for(:user, email: "invalid_email")

        expect {
          post :create, params: { user: user_attributes }
        }.not_to change(User, :count)

        expect(response).to have_http_status("422")
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["code"]).to eq(422)
        expect(json_response["status"]["message"]).to include('User couldn\'t be created successfully')
        expect(json_response["status"]["message"]).to include("Email is invalid")
      end
    end
  end
end
