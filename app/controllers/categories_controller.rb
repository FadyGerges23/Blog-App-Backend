class CategoriesController < ApplicationController
    def index
        @categories = []
        Category.all.each do |category|
            @categories.push(CategorySerializer.new(category).serializable_hash[:data][:attributes])
        end

        render json: { categories: @categories }, status: :ok
    end
end
