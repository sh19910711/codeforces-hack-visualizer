require "sinatra/base"
require "slim"
require "slim/include"
require "json"
require "codeforces"

class Server < ::Sinatra::Base

  get "/" do
    slim :empty
  end

  get "/contests/-/:contest_id" do |contest_id|
    slim :empty
  end

  get "/api/contests" do
    content_type :json
    contests.to_json
  end

  get "/api/contests/:contest_id" do |contest_id|
    contest = ::Codeforces.contest(contest_id.to_i)
    {
      :id => contest.id,
      :title => contest.name,
      :start => contest.startTimeSeconds,
      :duration => contest.durationSeconds,
    }.to_json
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

  def contests
    $contests ||= ::Codeforces.contests.grep(:type => "CF", :phase => "FINISHED").map do |contest|
      {
        :id => contest.id,
        :title => contest.name,
      }
    end.to_a
  end

end
