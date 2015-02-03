require "spec_helper"

describe ::Models::Contest do

  describe "#as_json" do
    
    context "create model" do
      let!(:model) { ::Models::Contest.create :id => 123, :title => "Contest Name" }
      context "as_json" do
        subject { model.as_json }
        it { should have_key "_id" }
        it { should have_key "title" }
      end
    end

  end

  describe "#self.fetch_all" do

    context "fetch_all" do
      before { ::Models::Contest.fetch_all }
      context "find 512" do
        subject! { ::Models::Contest.find 512 }
        it { expect(subject.title).to eq "Codeforces Round #290 (Div. 1)" }
      end
    end

  end # fetch_all

end # ::Models::Contest

