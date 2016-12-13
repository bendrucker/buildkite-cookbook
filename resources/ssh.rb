resource_name :buildkite_key

actions :create, :delete
default_action :create

property :path, String, default: ::File.join(node['buildkite']['ssh_path'], 'id_rsa')
property :owner, String, default: node['buildkite']['user']
property :content, String, regex: /BEGIN RSA PRIVATE KEY/, required: true

action :create do
  file new_resource.path do
    content new_resource.content
    mode '0400'
    owner new_resource.owner
    group new_resource.owner
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end
