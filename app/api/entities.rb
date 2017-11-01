module Entities
  class User < Grape::Entity
    expose :name
    expose :nickname
    expose :user_avatar
  end

  class Device < Grape::Entity
    expose :title
    expose :uid
    expose :token
    expose :user, using: Entities::User
    expose :is_returned
  end
end
