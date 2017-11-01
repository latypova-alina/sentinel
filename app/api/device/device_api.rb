class DeviceAPI < Grape::API
  resource :devices do

    desc "List all devices"
    get "all" do
      devices = Device.all
      present devices, with: Entities::Device
    end

    desc "Show device"
    params do
      requires :uid, type: String
    end
    get "/:uid" do
      device = Device.find_by(uid: params[:uid])
      present device, with: Entities::Device
    end

    desc "Create new device"
    params do
      requires :device, type: Hash do
        requires :title, type: String
        requires :uid, type: String
        requires :iid, type: String
      end
    end
    post "create" do
      device_params = params[:device]
      device = Device.find_by(uid: device_params[:uid])
      if device.nil?
        device = Device.create(title: device_params[:title], uid: device_params[:uid], iid: device_params[:iid])
      else
        device.update_attributes(title: device_params[:title], iid: device_params[:iid])
      end
      present status: 200 if device.save
    end

    desc "Update apn_token"
    params do
      requires :uid, type: String
      requires :token, type: String
    end
    post "/:uid/apn_token" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(token: params[:token])
      present status: 200 if device.save
    end

    desc "Delete apn_token"
    params do
      requires :uid, type: String
    end
    delete ":/uid/apn_token" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(token: nil)
      present status: 200 if device.save
    end

    desc "Take device"
    params do
      requires :uid, type: String
      requires :user_id, type: String
    end
    post "take" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(user_id: params[:user_id], is_returned: false)
      present status:200 if device.save
    end

    desc "Return device"
    params do
      requires :uid, type: String
    end
    post "return" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(user_id: nil, is_returned: true)
      present status:200 if device.save
    end

    desc "Send notification"
    params do
      requires :token, type: String
      requires :type, type: String
    end
    post "notify" do
      app = Rpush::Apns::App.find_by_name("sentinel-api3")
      if app.nil?
        app = Rpush::Apns::App.new
        app.name = "sentinel-api3"
        app.certificate = File.read("config/apns.pem")
        app.password = ENV.fetch("CERTIFICATE_PASSWORD")
        app.environment = "development"
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
      requires :uid, type: String
      optional :display_name, type: String
    end
    post "call" do
      app = Rpush::Apns::App.find_by_name("sentinel-api3")
      if app.nil?
        app = Rpush::Apns::App.new
        app.name = "sentinel-api3"
        app.certificate = File.read("config/apns.pem")
        app.password = ENV.fetch("CERTIFICATE_PASSWORD")
        app.environment = "development"
        app.connections = 1
        app.save!
      end
      ios = Rpush::Apns::Notification.new
      ios.app = app
      ios.device_token = Device.find_by(uid: params[:uid]).token
      # ios.data = { type: "call", displayName: params[:display_name] }
      ios.alert = "Provetiki"
      if ios.save!
        present status 200
      else
        present status 400
      end
    end
  end
end
