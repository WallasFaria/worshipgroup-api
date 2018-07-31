class UserInstrument < ApplicationRecord
  belongs_to :user
  belongs_to :instrument

  validates_uniqueness_of :user, scope: :instrument
  validates_presence_of :user, :instrument
end
