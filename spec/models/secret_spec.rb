require 'spec_helper'

describe Secret do
  before do
    @user = User.create(
      username: "joshcox",
      email: "joshcox@indiana.edu",
      name: "Josh Cox",
      password: "joshrlysux",
      password_confirmation: "joshrlysux"
    )
    @secret = Secret.new(
      key: "super sekrit key",
      value: "super sekrit value",
      user_id: @user.id
    )
  end

  subject { @secret }

  it { should respond_to(:key) }
  it { should respond_to(:value) }
  it { should respond_to(:client_iv) }
  it { should respond_to(:user_id) }

  it { should be_valid }

  describe "when key is not present" do
    before { @secret.key = "" }
    it { should_not be_valid }
  end

  describe "when value is not present" do
    before { @secret.value = "" }
    it { should_not be_valid }
  end

  describe "when key is not unique for one user" do
    before do
      secret2 = @secret.dup
      secret2.save
    end

    it { should_not be_valid }
  end

  describe "when two keys are unique for the same user" do
    before do
      secret2 = Secret.create(
        key: 'a different super sekrit key',
        value: 'some super sekrit message',
        user_id: @user.id
      )
    end

    it { should be_valid }
  end

  describe "when two users have a secret with the same key" do
    before do
      user2 = User.create(
        username: 'wert',
        password: 'asdfasdf',
        password_confirmation: 'asdfasdf'
      )
      secret2 = @secret.dup
      secret2.user_id = user2.id
      secret2.save
    end

    it { should be_valid }
  end
end
