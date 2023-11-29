class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :tags

  validates :title, presence: true
  validates :body, presence: true

  paginates_per 10

  def self.ransackable_attributes(auth_object = nil)
    ["title", "body", "category_id"]
  end

end
