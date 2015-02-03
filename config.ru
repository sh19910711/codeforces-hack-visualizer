require "bundler/setup"

require "mongoid"
Mongoid.load! "./mongoid.yml"

require_relative "lib/server"
run Server
