class Bloomy < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_token_authenticatable

  validates :first_name, presence: true, on: :create

  has_and_belongs_to_many :missions
  has_and_belongs_to_many :programs
end
