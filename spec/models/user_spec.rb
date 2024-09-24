require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'validations' do
    subject { User.new(email: 'hellothere@gmail.com', password: 'password', password_confirmation: 'password') } #needed for uniqueness validation

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }
    it { should have_secure_password }
  end

  it 'should generate an api key' do
    user = User.new(email: 'hellothere@gmail.com', password: 'password', password_confirmation: 'password')
    
    expect(user.api_key).to be_nil

    user.save
    
    expect(user.api_key).to_not be_nil
  end
end