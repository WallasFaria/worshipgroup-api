class Group < ApplicationRecord
  belongs_to :user
  has_many :musics

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates_presence_of :user_id

  validate :number_of_records_per_user

  MAX_RECORDS_PER_USER = 5

  private

    def number_of_records_per_user
      if Group.where(user: user_id).count >= MAX_RECORDS_PER_USER
        n = MAX_RECORDS_PER_USER
        errors.add(:user_id, "this user can have a maximum of #{n} groups")
      end
    end
end
