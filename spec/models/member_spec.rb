require 'rails_helper'

RSpec.describe Member, type: :model do
  it { should belong_to(:group) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:group) }
  it { should validate_presence_of(:rule) }

  # it { should validate_uniqueness_of(:user_id).scoped_to(:group) }

  it { should validate_inclusion_of(:rule).in_array(%w[admin collaborator default]) }
end
