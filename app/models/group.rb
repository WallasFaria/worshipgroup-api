class Group < ApplicationRecord
  attr_writer :user_id
  has_many :songs, dependent: :delete_all
  has_many :members, dependent: :delete_all

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
