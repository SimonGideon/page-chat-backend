class City < ApplicationRecord
  belongs_to :country, foreign_key: :country_code, primary_key: :code

  validates :name, :country_code, presence: true

  scope :by_country, ->(country_code) { where(country_code: country_code) }
  scope :ordered, -> { order(:name) }

  # Alias for serializer compatibility
  def country_id
    country_code
  end
end

