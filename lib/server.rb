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

  def contests
    $contests ||= ::Codeforces.contests.grep(:type => "CF", :phase => "FINISHED").map do |contest|
      {
        :id => contest.id,
        :title => contest.name,
      }
    end.to_a
  end

  get "/api/contests" do
    content_type :json
    contests.to_json
  end

end
