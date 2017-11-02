class API < Grape::API
  prefix 'api'
  format :json
  version 'v1', using: :path

  mount UserAPI
  mount DeviceAPI
  add_swagger_documentation api_version: 'v1', hide_format: true
end
