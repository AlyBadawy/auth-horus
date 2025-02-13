class User < ApplicationRecord
  has_secure_password
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true

  has_and_belongs_to_many :roles # rubocop:disable Rails/HasAndBelongsToMany
  has_many :sessions, dependent: :destroy
  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :profile
end
