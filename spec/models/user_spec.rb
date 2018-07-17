require 'rails_helper'

RSpec.describe User, type: :model do

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :telephone }
  it { should respond_to :date_of_birth }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :date_of_birth }

  # it { should validate_uniqueness_of(:email).case_insensitive }

end
