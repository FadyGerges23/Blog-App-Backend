class Category < ApplicationRecord
  has_many :post

  validates :name, presence: true
end
