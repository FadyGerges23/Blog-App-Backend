class Tag < ApplicationRecord
    has_and_belongs_to_many :posts

    validates :name, presence: true

    def self.ransackable_attributes(auth_object = nil)
        ["id", "name"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["posts"]
      end
end
