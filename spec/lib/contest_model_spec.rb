require "spec_helper"

describe ::Models::Contest do

  describe "#fetch_hacks" do

    let!(:contest) { ::Models::Contest.create :id => 512, :title => "Contest Name" }

    context "fetch_hacks" do

      before { contest.fetch_hacks }
      it { expect(contest.hacks).to_not be_empty }
      it { expect(contest.fetched_hacks).to be_truthy }

      context "hackers" do
        subject { contest.hackers }
        it { should include "ahmed_aly" }
        it { should include "Haghani" }
        it { should include "IvL" }
      end

      context "defender" do
        subject { contest.defender }
        it { should include "MrDindows" }
        it { should include "kcm1700" }
        it { should include "rares.buhai" }
      end

    end

  end #fetch_hacks

  describe "#as_json" do
    
    context "create model" do

      let!(:contest) { ::Models::Contest.create :id => 123, :title => "Contest Name" }

      context "as_json" do
        subject { contest.as_json }
        it { should have_key "_id" }
        it { should have_key "title" }
        it { should have_key "start" }
        it { should have_key "duration" }
      end

    end

  end #as_json

  describe "#self.fetch_all" do

    context "fetch_all" do

      before { ::Models::Contest.fetch_all }

      context "find 512" do
        subject! { ::Models::Contest.find 512 }
        it { expect(subject.title).to eq "Codeforces Round #290 (Div. 1)" }
        it { expect(subject.start).to eq Time.at(1422894600) }
      end

    end

  end #fetch_all

end # ::Models::Contest

