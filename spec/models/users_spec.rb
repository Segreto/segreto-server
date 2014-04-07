require 'spec_helper'
describe User do
  before do
    @user = User.new(
      username: "joshcox",
      email: "joshcox@indiana.edu",
      name: "Josh Cox",
      password: "joshrlysux",
      password_confirmation: "joshrlysux"
    )
  end

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when username is not present" do
    before { @user.username = "" }
    it { should_not be_valid }
  end

  describe "when username is not unique" do
    before do 
      user2 = @user.dup
      user2.username = user2.username.upcase
      user2.save
    end

    it { should_not be_valid }
  end

  describe "when username is too long" do
    before { @user.username = "a" * 25 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      invalid_emails = %w[mdewitt josh.cox.com mike@dewitt wat@mike_josh.com]
      invalid_emails.each do |email|
        @user.email = email
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      valid_emails = %w[josh@mike.com josh+mike@beast.com josh@COX.coM]
      valid_emails.each do |email|
        @user.email = email
        expect(@user).to be_valid
      end
    end
  end

  describe "when name is too long" do
    before { @user.name = "a" * 101 }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  describe "when password does not match password_confirmation" do
    before { @user.password_confirmation = "butrlydoe" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { should be_invalid }
  end

  describe "authentication" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end
