class Presentation < ApplicationRecord
  belongs_to :group

  has_many :members, class_name: :PresentationsMember
  has_many :songs, class_name: :PresentationsSong

  validates :date, presence: true
end
