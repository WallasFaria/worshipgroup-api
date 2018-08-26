class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :members
  has_many :groups, through: :members

  has_many :user_roles, dependent: :delete_all
  has_many :roles, through: :user_roles

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :date_of_birth, presence: true

  def is_an_admin_member?(group)
    member = members.find_by(group_id: group.id)
    return false if member.nil?
    member.permission == 'admin'
  end
end
