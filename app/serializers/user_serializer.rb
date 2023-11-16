class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :username, :display_name
end
