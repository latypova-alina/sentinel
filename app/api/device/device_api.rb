class DeviceAPI < Grape::API
  resource :devices do
    desc "Create new device"
    params do
      requires :device, type: Hash do
        requires :name, type: String
        optional :title, type: String
        optional :last_user, type: String
        optional :is_returned, type: Boolean
      end
    end

    post "create" do
      device_params = params[:device]
      device = Device.find_by(name: device_params[:name])
      if device.nil?
        byebug
        device = Device.create(name: device_params[:name], token: device_params[:token], user_id: device_params[:last_user])
      else
        device.update_attributes(token: device_params[:token], user_id: device_params[:last_user])
      end
      present status: 200 if device.save
    end

  end
end
