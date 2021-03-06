class Agent < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  include DeviseTokenAuth::Concerns::User

  has_many :tickets
  has_many :customers, through: :tickets

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
