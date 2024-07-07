class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true
  validates :biography, presence: true
end
