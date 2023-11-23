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
            render json: { message: "Post created successfully!", post: PostSerializer.new(@post).serializable_hash[:data][:attributes]}, status: :created
        else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        @user = User.find(params[:user_id])
        @post = @user.posts.find(params[:id])

        if @post.update(post_params)
            render json: { message: "Post updated successfully!", post: PostSerializer.new(@post).serializable_hash[:data][:attributes] }, status: :ok
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
        serialized_post
    end

    def post_params
        params.require(:post).permit(:title, :body, :category_id)
    end
end
