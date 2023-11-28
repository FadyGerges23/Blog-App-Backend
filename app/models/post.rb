class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :tags

  validates :title, presence: true
  validates :body, presence: true

  paginates_per 10
end
