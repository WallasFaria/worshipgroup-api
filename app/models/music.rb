class Music < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :artist }
  validates :artist, presence: true
end
