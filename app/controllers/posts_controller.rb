class PostsController < ApplicationController
    
    def index
        post_filters = PostFilters.new(params, Post)
        filtered_posts = post_filters.filter
        
        @posts = filtered_posts.order(created_at: :desc).page(params[:page])
        serialized_posts = @posts.map do |post|
            serialize_post(post)
        end

        render json: { 
            posts: serialized_posts,
            pagesCount:  @posts.total_pages
        }, status: :ok

    end

    def show
        @post = Post.find(params[:id])
        serialized_post = serialize_post(@post)
        render json: serialized_post, status: :ok
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
        
        serialized_post[:user] = UserSerializer.new(post.user).serializable_hash[:data][:attributes]      
        serialized_post[:user][:displayName] = serialized_post[:user].delete(:display_name)
        serialized_post[:user][:avatar] = serialized_post[:user].delete(:avatar_url)

        serialized_post
    end

    def post_params
        params.require(:post).permit(:title, :body, :category_id)
    end
end
