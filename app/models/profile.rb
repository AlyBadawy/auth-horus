class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
