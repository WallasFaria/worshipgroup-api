class PresentationsMember < ApplicationRecord
  belongs_to :member
  belongs_to :presentation

  def name
    self.member.user.name
  end
end
