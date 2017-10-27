class UserAPI < Grape::API
  resource :users do
    desc "List all User"

    get "show_users" do
      users = User.all
      present users, with: Entities::User
    end
  end
end
