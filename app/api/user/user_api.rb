class UserAPI < Grape::API
  resource :users do
    desc "List all users"

    get "all" do
      users = User.all
      present users, with: Entities::User
    end

    desc "Create new user"
    params do
      requires :user, type: Hash do
        requires :name, type: String
        requires :nickname, type: String
        optional :user_avatar, type: String
      end
    end

    post "create" do
      user_params = params[:user]
      user = User.create(name: user_params[:name], nickname: user_params[:nickname], user_avatar: user_params[:user_avatar])
      user.save
      present status: 200
    end
  end
end
