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
end
