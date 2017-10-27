module Entities
  class User < Grape::Entity
    format_with(:iso_timestamp) { |dt| dt.iso8601 }
    expose :name
    expose :nickname
    expose :user_avatar
  end
end
