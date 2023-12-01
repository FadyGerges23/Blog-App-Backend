class PostFilters
    def initialize(params, posts)
        @params = params
        @posts = posts
    end

    def filter
        post_filters = {
            title_cont: @params.dig(:q, :title_cont),
            body_cont: @params.dig(:q, :body_cont),
            category_id_eq: @params.dig(:q, :category_id_eq)
        }

        tags_filters = {
            id_in: @params.dig(:q, :id_in)
        }

        filtered_posts = @posts.ransack(post_filters).result.includes(:tags)
        filtered_tags = Tag.ransack(tags_filters).result.pluck(:id)
        filtered_posts_tags = filtered_posts.joins(:tags).where(tags: { id: filtered_tags }).distinct
    end

end