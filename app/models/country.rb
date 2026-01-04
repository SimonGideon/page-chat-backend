class Country < ApplicationRecord
  self.primary_key = :code
  
  has_many :cities, foreign_key: :country_code, dependent: :destroy
  has_many :users, foreign_key: :country_code, dependent: :restrict_with_error

  validates :name, :code, presence: true
  validates :code, uniqueness: true, length: { is: 2 }
  validates :iso3, uniqueness: true, allow_nil: true, length: { is: 3 }

  scope :ordered, -> { order(:name) }
end

