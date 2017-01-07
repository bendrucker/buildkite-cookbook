resource_name :buildkite_key

actions :create, :delete
default_action :create

property :name, String, name_property: true
property :owner, String, default: node['buildkite']['user']
property :content, String, regex: /BEGIN RSA PRIVATE KEY/, required: true

path = node['buildkite']['paths']['ssh']

action :create do
  file ::File.join(path, new_resource.name) do
    content new_resource.content
    mode '0400'
    owner new_resource.owner
    group new_resource.owner
  end
end

action :delete do
  file ::File.join(path, new_resource.name) do
    action :delete
  end
end
