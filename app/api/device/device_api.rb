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
        requires :uid, type: String
        optional :token, type: String
        optional :last_user, type: String
        optional :is_returned, type: Boolean
      end
    end

    post "create" do
      device_params = params[:device]
      device = Device.find_by(name: device_params[:name])
      if device.nil?
        device = Device.create(name: device_params[:name], uid: device_params[:uid], token: device_params[:token], user_id: device_params[:last_user])
      else
        device.update_attributes(token: device_params[:token], uid: device_params[:uid], user_id: device_params[:last_user])
      end
      present status: 200 if device.save
    end

    desc "Take device"
    params do
      requires :device_uid, type: String
      requires :user_id, type: String
    end

    post "take" do
      byebug
      device = Device.find_by(uid: params[:device_uid])
      device.update_attributes(user_id: params[:user_id], is_returned: false)
      present status:200 if device.save
    end

    desc "Return device"
    params do
      requires :device_uid, type: String
      requires :user_id, type: String
    end

    post "return" do
      device = Device.find_by(uid: params[:device_uid])
      device.update_attributes(user_id: params[:user_id], is_returned: true)
      present status:200 if device.save
    end

    desc "Send notification"
    params do
      requires :token, type: String
      requires :type, type: String
    end

    get "notify" do
      app = Rpush::Apns::App.find_by_name("sentinel-api2")
      if app.nil?
        app = Rpush::Apns::App.new
        app.name = "sentinel-api2"
        app.certificate = File.read("config/apns.pem")
        app.password = ENV.fetch("CERTIFICATE_PASSWORD")
        app.environment = "production"
        app.connections = 1
        app.save!
      end
      ios = Rpush::Apns::Notification.new
      ios.app = app
      ios.device_token = params[:token]
      ios.alert = "nu provetik"
      if ios.save!
        present status 200
      else
        present status 400
      end
    end

    desc "Send call notification"
    params do
      requires :device_uid, type: String
    end

    get "call" do
      app = Rpush::Apns::App.find_by_name("sentinel-api2")
      if app.nil?
        app = Rpush::Apns::App.new
        app.name = "sentinel-api2"
        app.certificate = File.read("config/apns.pem")
        app.password = ENV.fetch("CERTIFICATE_PASSWORD")
        app.environment = "production"
        app.connections = 1
        app.save!
      end
      ios = Rpush::Apns::Notification.new
      ios.app = app
      ios.device_token = Device.find_by(uid: params[:device_uid]).token
      ios.data = { type: "call" }
      if ios.save!
        present status 200
      else
        present status 400
      end
    end
  end
end
