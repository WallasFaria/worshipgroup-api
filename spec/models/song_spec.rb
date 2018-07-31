require 'rails_helper'

RSpec.describe Song, type: :model do
  it { should respond_to :name }
  it { should respond_to :artist }
  it { should respond_to :url_youtube }
  it { should respond_to :url_cipher }

  it { should belong_to :group }

  it { should validate_presence_of :name }
  it { should validate_presence_of :artist }

  it { should validate_uniqueness_of(:name).scoped_to(:artist) }
end
