class Models::Contest

  include ::Mongoid::Document

  field :title, :type => String
  field :start, :type => Time
  field :duration, :type => Integer

  field :fetched_hacks, :type => Boolean
  has_and_belongs_to_many :hacks, :class_name => "::Models::Hack"

  field :fetched_users, :type => Boolean
  has_and_belongs_to_many :users, :class_name => "::Models::User"

  def hackers
    hacks.map {|hack| hack.hacker }
      .sort
      .uniq
  end

  def defender
    hacks.map {|hack| hack.defender }
      .sort
      .uniq
  end

  def fetch_hacks
    return if fetched_hacks
    ::Codeforces.api.contest.hacks(id.to_i).map do |hack|
      hack_model = hacks.find_or_create_by(:id => hack.id)
      hack_model.update_attributes(
        :hacker => hack.hacker.members.first.handle,
        :defender => hack.defender.members.first.handle,
        :time => Time.at(hack.creationTimeSeconds),
        :verdict => hack.verdict === "HACK_SUCCESSFUL",
        :problem => hack.problem.index,
      )
    end
    update_attributes! :fetched_hacks => true
  end

  def as_simple_json
    {
      :_id => id,
      :title => title,
    }
  end

  def self.fetch_all
    ::Codeforces.contests.grep(:type => "CF", :phase => "FINISHED").each do |contest|
      model = find_or_create_by(:id => contest.id)
      model.update_attributes(
        :title => contest.name,
        :start => Time.at(contest.startTimeSeconds),
        :duration => contest.durationSeconds,
      )
      model.save!
    end
  end

end

