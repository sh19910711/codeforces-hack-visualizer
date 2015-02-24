require "bundler/setup"
require "mongoid"
require_relative "../lib/server"

Mongoid.load! "mongoid.yml"
Models::Contest.fetch_all

Models::Contest.all.desc(:id).each do |contest|
  puts "fetch: #{contest.id} (#{contest.title})"
  unless contest.fetched_hacks
    puts "fetch: #{contest.id}: hacks"
    contest.fetch_hacks
  end
  unless contest.fetch_users
    puts "fetch: #{contest.id}: users"
    contest.fetch_users
  end
  puts "finish: #{contest.id}: "
end

