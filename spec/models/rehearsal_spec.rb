require 'rails_helper'

RSpec.describe Rehearsal, type: :model do
  it { should validate_presence_of :date }
end
