class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :roles # rubocop:disable Rails/HasAndBelongsToMany

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true
end
