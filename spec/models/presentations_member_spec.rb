require 'rails_helper'

RSpec.describe PresentationsMember, type: :model do
  it { should belong_to :presentation }
  it { should belong_to :member }

  it { should respond_to :name }
end
