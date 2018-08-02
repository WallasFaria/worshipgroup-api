require 'rails_helper'

RSpec.describe PresentationsSong, type: :model do
  it { should belong_to :presentation }
  it { should belong_to :song }

  it { should respond_to :name }
  it { should respond_to :artist }
  it { should respond_to :tone }
  it { should respond_to :url_video }
  it { should respond_to :url_cipher }
end
