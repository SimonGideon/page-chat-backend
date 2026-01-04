require "rails_helper"

RSpec.describe "API V1 Books", type: :request do
  describe "GET /books/recommended" do
    it "returns public book data under the versioned path" do
      recommended_book = create(:book, recommended: true)

      get api_v1_path("/books/recommended")

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("status", "message")).to eq("Successfully fetched books.")
      titles = body.fetch("data").map { |book| book["title"] }
      expect(titles).to include(recommended_book.title)
    end
  end
end
