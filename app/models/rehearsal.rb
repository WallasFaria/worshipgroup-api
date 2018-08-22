class Rehearsal < ApplicationRecord
  belongs_to :presentation

  validates :date, presence: true
end
