class Models::Hack

  include ::Mongoid::Document

  field :hacker, :type => String
  field :defender, :type => String
  field :time, :type => Time
  field :verdict, :type => Boolean
  field :problem, :type => String

end

