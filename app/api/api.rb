class API < Grape::API
  prefix 'api'
  format :json
  version 'v1', using: :path

  mount UserAPI
  mount DeviceAPI
  mount PhotoCallbackAPI

  add_swagger_documentation api_version: 'v1'
end
