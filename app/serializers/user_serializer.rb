class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :username, :display_name, :avatar_url, :posts

  def avatar_url
    object.avatar.url
  end
end
