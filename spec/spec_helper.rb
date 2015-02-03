require "bundler/setup"

ENV["RACK_ENV"] = "test"

require "rack/test"

def fixtures(path)
  ::File.expand_path(::File.join __FILE__, "..", "fixtures", path)
end

require "webmock"
RSpec.configure do |config|

  def stub_json(url, fixture_filename)
    ::WebMock.stub_request(:get, url).to_return(
      :body => ::File.read(fixtures fixture_filename),
      :headers => {
        "Content-Type" => "application/json",
      },
    )
  end

  config.before do
    stub_json "http://codeforces.com/api/contest.list", "codeforces_api/contest_list.json"
    stub_json "http://codeforces.com/api/contest.hacks?contestId=512", "codeforces_api/hacks_512.json"
  end

  config.before do
    ::WebMock.stub_request(
      :get,
      "http://codeforces.com/api/contest.list",
    ).to_return(
      :body => ::File.read(fixtures "codeforces_api/contest_list.json"),
      :headers => {
        "Content-Type" => "application/json",
      },
    )
  end

  config.after { ::WebMock.reset! }

end

require "mongoid"
Mongoid.load! "mongoid.yml"

require "database_cleaner"
RSpec.configure do |config|
  config.before { ::DatabaseCleaner.strategy = :truncation }
  config.after { ::DatabaseCleaner.clean }
end

require "server"

