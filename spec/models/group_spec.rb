require 'rails_helper'

RSpec.describe Group, type: :model do
  it { should respond_to(:name) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
end
