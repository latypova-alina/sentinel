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
    get do
      device = Device.find_by(uid: params[:uid])
      present device, with: Entities::Device
    end

    desc "Create new device"
    params do
      requires :title, type: String
      requires :uid, type: String
      requires :iid, type: String
    end
    post do
      device = Device.find_by(uid: params[:uid])
      if device.nil?
        device = Device.create(title: params[:title], uid: params[:uid], iid: params[:iid])
      else
        device.update_attributes(title: params[:title], iid: params[:iid])
      end
      present device, with: Entities::Device if device.save
    end

    desc "Update apn_token"
    params do
      requires :uid, type: String
      requires :apn_token, type: String
    end
    post "/apn_token" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(apn_token: params[:apn_token])
      present status: 200 if device.save
    end

    desc "Delete apn_token"
    params do
      requires :uid, type: String
    end
    delete "/apn_token" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(apn_token: nil)
      present status: 200 if device.save
    end

    desc "Take device"
    params do
      requires :uid, type: String
      requires :user_id, type: String
    end
    post "/holder" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(user_id: params[:user_id], is_returned: false)
      present status: 200 if device.save
    end

    desc "Return device"
    params do
      requires :uid, type: String
    end
    delete "/holder" do
      device = Device.find_by(uid: params[:uid])
      device.update_attributes(user_id: nil, is_returned: true)
      present status:200 if device.save
    end

    desc "Send call notification"
    params do
      requires :uid, type: String
      optional :display_name, type: String
    end
    post "call" do
      app = Rpush::Apns::App.find_by_name("Sentinel1")
      if app.nil?
        app = Rpush::Apns::App.new
        app.name = "Sentinel1"
        app.certificate = File.read("config/apns.pem")
        app.password = ENV.fetch("CERTIFICATE_PASSWORD")
        app.environment = "development"
        app.connections = 1
        app.save!
      end
      ios = Rpush::Apns::Notification.new
      ios.app = app
      ios.device_token = Device.find_by(uid: params[:uid]).apn_token
      ios.data = { type: "call", displayName: params[:display_name] }
      ios.alert = "Call"
      ios.save!
      if ios.save!
        present status 200
      else
        present status 400
      end
    end

    desc "Send call notification by iid"
    params do
      requires :iid, type: String
      optional :display_name, type: String
    end
    post "call_by_iid" do
      app = Rpush::Apns::App.find_by_name("Sentinel1")
      if app.nil?
        app = Rpush::Apns::App.new
        app.name = "Sentinel1"
        app.certificate = File.read("config/apns.pem")
        app.password = ENV.fetch("CERTIFICATE_PASSWORD")
        app.environment = "development"
        app.connections = 1
        app.save!
      end
      ios = Rpush::Apns::Notification.new
      ios.app = app
      ios.device_token = Device.find_by(iid: params[:iid]).apn_token
      ios.data = { type: "call", displayName: params[:display_name] }
      ios.alert = "Call"
      ios.save!
      if ios.save!
        present status 200
      else
        present status 400
      end
    end

  end
end
