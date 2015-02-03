class Models::Contest

  include ::Mongoid::Document

  field :title, :type => String

  def self.fetch_all
    ::Codeforces.contests.each do |contest|
      model = find_or_create_by(
        :id => contest.id,
        :title => contest.name,
      )
    end
  end

end
