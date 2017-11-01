class UserAPI < Grape::API
  resource :users do

    desc "List all users"
    get "all" do
      users = User.all
      present users, with: Entities::User
    end

    desc "Create new user"
    params do
      requires :uid, type: String
      requires :name, type: String
      requires :nickname, type: String
      optional :user_avatar, type: String
    end
    post "create" do
      user = User.find_by(uid: params[:uid])
      if user.nil?
        user = User.create(uid: params[:uid], name: params[:name], nickname: params[:nickname], user_avatar: params[:user_avatar])
      else
        user.update_attributes(name: params[:name], nickname: params[:nickname], user_avatar: params[:user_avatar])
      end
      present user, with: Entities::User if user.save
    end

    desc "Delete user"
    params do
      requires :uid, type: String
    end
    delete do
      User.find_by(uid: params[:uid]).delete
      present status:200
    end

  end
end
