require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should respond_to :name }
  it { should respond_to :icon }

  it { should validate_presence_of :name }
  it { should validate_presence_of :icon }
end
