class Models::Contest

  include ::Mongoid::Document

  field :title, :type => String
  field :start, :type => Time
  field :duration, :type => Integer
  field :user_cached, :type => Boolean
  field :hacks_cached, :type => Boolean

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

