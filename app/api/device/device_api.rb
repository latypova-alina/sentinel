class DeviceAPI < Grape::API
  resource :devices do

    desc "List all devices"
    get "all" do
      devices = Device.all
      present devices, with: Entities::Device
    end

    desc "Create new device"
    params do
      requires :device, type: Hash do
        requires :name, type: String
        optional :token, type: String
        optional :last_user, type: String
        optional :is_returned, type: Boolean
      end
    end

    post "create" do
      device_params = params[:device]
      device = Device.find_by(name: device_params[:name])
      if device.nil?
        device = Device.create(name: device_params[:name], token: device_params[:token], user_id: device_params[:last_user])
      else
        device.update_attributes(token: device_params[:token], user_id: device_params[:last_user])
      end
      present status: 200 if device.save
    end

  end
end
