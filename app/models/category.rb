class Category < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
end
