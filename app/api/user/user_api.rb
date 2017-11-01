class UserAPI < Grape::API
  resource :users do

    desc "List all users"
    get "all" do
      users = User.all
      present users, with: Entities::User
    end

    desc "Create new user"
    params do
      requires :name, type: String
      requires :nickname, type: String
      optional :user_avatar, type: String
    end

    post "create" do
      user = User.create(name: params[:name], nickname: params[:nickname], user_avatar: params[:user_avatar])
      present status: 200 if user.save
    end
  end
end
