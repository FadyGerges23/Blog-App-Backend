class PostsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @user = User.find(params[:user_id])
        @posts = @user.posts
        serialized_posts = @posts.map do |post|
            serialize_post(post)
        end
        render json: { posts: serialized_posts }, status: :ok
    end

    def show
        @user = User.find(params[:user_id])
        @post = @user.posts.find(params[:id])
        serialized_post = serialize_post(@post)
        render json: serialized_post, status: :ok
    end
    
    def create
        @user = User.find(params[:user_id])
        @post = @user.posts.build(post_params)

        if @post.save
            tagsIds = params[:tags_ids]
            tagsIds.each do |tagId|
                @post.tags << Tag.find(tagId)
            end
            serialized_post = serialize_post(@post)
            render json: { message: "Post created successfully!", post: serialized_post}, status: :created
        else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        @user = User.find(params[:user_id])
        @post = @user.posts.find(params[:id])

        if @post.update(post_params)
            @post.tags.destroy_all
            tagsIds = params[:tags_ids]
            tagsIds.each do |tagId|
                @post.tags << Tag.find(tagId)
            end
            serialized_post = serialize_post(@post)
            render json: { message: "Post updated successfully!", post: serialized_post }, status: :ok
        else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:user_id])
        @post = @user.posts.find(params[:id])
        @post.destroy
        render json: { message: "Post deleted successfully!" }, status: :ok
    end

    private

    def serialize_post(post)
        serialized_post = PostSerializer.new(post).serializable_hash[:data][:attributes]
        serialized_post[:category] = CategorySerializer.new(post.category).serializable_hash[:data][:attributes]
        serialized_post[:tags] = post.tags.map do |tag|
            serialized_tag = TagSerializer.new(tag).serializable_hash[:data][:attributes]
            {
                tagId: serialized_tag[:id],
                name: serialized_tag[:name]
            }
        end
        serialized_post
    end

    def post_params
        params.require(:post).permit(:title, :body, :category_id)
    end
end
