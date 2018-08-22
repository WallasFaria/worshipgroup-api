class Presentation < ApplicationRecord
  belongs_to :group

  has_many :members, class_name: :PresentationsMember
  has_many :songs, class_name: :PresentationsSong
  has_many :rehearsals

  validates :date, presence: true
end
