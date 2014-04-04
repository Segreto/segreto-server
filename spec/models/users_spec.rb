require 'spec_helper'
describe User do
  before { @user = User.new(username:"joshcox", email:"joshcox@indiana.edu") }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }

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

  describe "when usernmae is too long" do
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
end
