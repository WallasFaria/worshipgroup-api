require 'rails_helper'

RSpec.describe Presentation, type: :model do
  it { should have_many :songs }
  it { should have_many :members }

  it { should validate_presence_of :date }
end
