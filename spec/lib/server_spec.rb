require "spec_helper"

describe ::Server do

  include ::Rack::Test::Methods

  def app
    ::Server
  end

  describe "routes" do

    context "GET /" do
      before { get "/" }
      subject { last_response }
      it { should be_ok }
    end

    context "GET /contests/-/123" do
      before { get "/contests/-/123" }
      subject { last_response }
      it { should be_ok }
    end

  end

end

