class DeviceAPI < Grape::API

  desc "Send photo callback notification"
  params do
    requires :session_id, type: String
    requires :device_uid, type: String
    requires :user_uid, type: String
    requires :confidence, type: Float
  end
  post "photo_callback" do
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
    ios.device_token = Device.find_by(uid: params[:device_uid]).apn_token
    ios.data = { session_id: params[:session_id], device_uid: params[:device_uid], user_uid: params[:user_uid], confidence: params[:confidence] }
    ios.alert = "PhotoCallback"
    ios.save!
    if ios.save!
      present status 200
    else
      present status 400
    end
  end
end
