require 'chefspec'
require 'chefspec/berkshelf'

Dir['libraries/*.rb'].each { |file| require File.expand_path(file) }