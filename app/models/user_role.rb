class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates_uniqueness_of :user, scope: :role
  validates_presence_of :user, :role
end
