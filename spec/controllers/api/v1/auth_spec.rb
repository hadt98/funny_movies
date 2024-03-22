require 'rails_helper'

RSpec.describe API::V1::Auth, type: :request do

  describe "POST /register" do
    context "email existed" do
      it "return email existed error" do
        create(:user, email: "test@gmail.com", password: "123123")
        post "/api/v1/auth/register", params: { email: "test@gmail.com", password: "123123" }, as: :json
        expect(response.status).to eq(422)
        expect(json_body["error"]).to eq "Email has already been taken"
      end
    end

    context "success" do
      it "return success" do
        post "/api/v1/auth/register", params: { email: "test@gmail.com", password: "123123" }, as: :json
        expect(response.status).to eq(201)
        expect(json_body["email"]).to eq "test@gmail.com"
      end
    end
  end

  describe "POST /login" do
    context "user not existed" do
      it "return error" do
        post_with_token "/api/v1/auth/login", body: { email: "test@gmail.com", password: "123123" }
        expect(response.status).to eq(401)
        expect(json_body["error"]).to eq "wrong password or email"
      end
    end
    context "wrong password" do
      it "return error" do
        create(:user, email: "test@gmail.com", password: "123123")
        post_with_token "/api/v1/auth/login", body: { email: "test@gmail.com", password: "43545" }
        expect(response.status).to eq(401)
        expect(json_body["error"]).to eq "wrong password or email"
      end
    end
    context "login success" do
      it "return success" do
        create(:user, email: "test@gmail.com", password: "123123")
        post_with_token "/api/v1/auth/login", body: { email: "test@gmail.com", password: "123123" }
        expect(response.status).to eq(201)
        expect(json_body).to have_key("token")
      end
    end
  end

end