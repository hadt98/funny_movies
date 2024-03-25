require 'rails_helper'

RSpec.describe API::V1::Users, type: :request do
  describe "GET /me" do
    context "get current user email" do
      it "return success" do
        user = create(:user)
        get_with_token "/api/v1/users/me", user: user
        expect(response.status).to eq(200)
        expect(json_body["email"]).to eq user.email
      end
    end

    context "unauthenticated user" do
      it "return error" do
        get_without_token "/api/v1/users/me"
        expect(response.status).to eq(401)
      end
    end
  end
end