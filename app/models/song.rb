class Song < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :artist }
  validates :artist, presence: true

  belongs_to :group
end
