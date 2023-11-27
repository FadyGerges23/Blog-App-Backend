class TagsController < ApplicationController
    before_action :authenticate_user!, only: [:create]

    def index
        @tags = []
        Tag.all.each do |tag|
            @tags.push(TagSerializer.new(tag).serializable_hash[:data][:attributes])
        end
        render json: { tags: @tags }, status: :ok
    end

    def create
        @tag = Tag.new(tag_params)
        if @tag.save
            render json: { tag: TagSerializer.new(@tag).serializable_hash[:data][:attributes] }, status: :ok
        else
            render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def tag_params
        params.require(:tag).permit(:name)
    end

end
