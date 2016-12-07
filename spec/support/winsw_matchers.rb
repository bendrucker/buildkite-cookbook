if defined?(ChefSpec)
  def install_winsw(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:winsw, :install, resource_name)
  end
end