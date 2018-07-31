class Member < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates_uniqueness_of :user, scope: :group
  validates_presence_of :user, :group
  validates :rule, presence: true,
                   inclusion: { in: %w[admin collaborator default] }
end
