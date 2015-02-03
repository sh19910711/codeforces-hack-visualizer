require "bundler/setup"

require "rspec/core/rake_task"
::RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = [
    "--format doc",
    "--color",
  ]
end

task "db:clean" do
  require "mongoid"
  ENV["RACK_ENV"] = "development"
  Mongoid.load! "mongoid.yml"
  require "database_cleaner"
  DatabaseCleaner.clean
end

