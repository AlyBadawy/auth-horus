class Role < ApplicationRecord
  has_and_belongs_to_many :users # rubocop:disable Rails/HasAndBelongsToMany

  normalizes :role_name, with: ->(e) { e.strip.titleize }
  validates :role_name, presence: true, uniqueness: true
end
