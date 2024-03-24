require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.create!(password: "123123", email: "example@example.com")
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    expect {
      User.create!(password: "123123")
    }.to raise_error(ActiveRecord::RecordInvalid)

  end

  it "is not valid with an invalid email format" do
    expect {
      User.create!(password: "123123", email: "invalid_email")
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end