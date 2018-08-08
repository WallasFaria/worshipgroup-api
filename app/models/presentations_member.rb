class PresentationsMember < ApplicationRecord
  belongs_to :member
  belongs_to :presentation

  has_and_belongs_to_many :roles

  def name
    self.member.user.name
  end
end
