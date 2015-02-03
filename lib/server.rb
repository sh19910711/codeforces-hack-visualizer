require "sinatra/base"
require "slim"
require "slim/include"
require "json"
require "codeforces"

require_relative "models"

class Server < ::Sinatra::Base

  configure :development do
    require "sinatra/reloader"
    register ::Sinatra::Reloader
  end

  configure :development do
    require "better_errors"
    use ::BetterErrors::Middleware
    ::BetterErrors.application_root = __dir__
  end

  get "/" do
    slim :empty
  end

  get "/contests/-/:contest_id" do |contest_id|
    slim :empty
  end

  get "/admin" do
    slim :empty
  end

  before "/api/*" do
    content_type :json
  end

  get "/api/users" do
  end

  get "/api/contests" do
    ::Models::Contest.all.order_by(:id.desc).map(&:as_simple_json).to_json
  end

  get "/api/contests/:contest_id" do |contest_id|
    ::Models::Contest.find(contest_id.to_i).as_json.to_json
  end

  get "/api/contests/:contest_id/hacks" do |contest_id|
    ::Codeforces.api.contest.hacks(contest_id.to_i).map do |hack|
      {
        :id => hack.id,
        :hacker => hack.hacker.members.first.handle,
        :defender => hack.defender.members.first.handle,
        :time => hack.creationTimeSeconds,
        :verdict => hack.verdict === "HACK_SUCCESSFUL",
        :problem => hack.problem.index,
      }
    end.to_a.to_json
  end

  patch "/api/users" do
  end

  patch "/api/contests" do
    ::Models::Contest.fetch_all
    {}.to_json
  end

end
