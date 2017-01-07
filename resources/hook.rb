resource_name :buildkite_hook

actions :create, :delete
default_action :create

property :name, String, required: true
property :code, String, required: true

path = node['buildkite']['paths']['hooks']

action :create do
  file ::File.join(path, new_resource.name) do
    content new_resource.code
    mode '0700'
    owner node['buildkite']['user']
    group node['buildkite']['user']
  end
end

action :delete do
  file ::File.join(path, new_resource.name) do
    action :delete
  end
end
