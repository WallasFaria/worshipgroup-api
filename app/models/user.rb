class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :members
  has_many :groups, through: :members

  has_many :user_instruments, dependent: :delete_all
  has_many :instruments, through: :user_instruments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :date_of_birth, presence: true
end
