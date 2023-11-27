class PostSerializer
    include JSONAPI::Serializer
    attributes :id, :title, :body
end