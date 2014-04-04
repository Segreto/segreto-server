require 'spec_helper'
describe User do
  before { @user = User.new(username:"joshcox", email:"joshcox@indiana.edu") }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
end
