class UsersSerializer
  include JSONAPI::Serializer

  set_type :user
  attributes :email, :api_key

end