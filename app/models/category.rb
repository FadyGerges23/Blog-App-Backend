class Category < ApplicationRecord
  has_many :post

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

end
