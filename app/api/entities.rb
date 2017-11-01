module Entities
  class User < Grape::Entity
    expose :id
    expose :name
    expose :nickname
    expose :user_avatar
  end

  class Device < Grape::Entity
    expose :title
    expose :uid
    expose :iid
    expose :apn_token
    expose :user, using: Entities::User
    expose :is_returned
  end
end
