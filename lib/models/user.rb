class Models::User

  include ::Mongoid::Document

  field :handle, :type => String
  field :country, :type => String
  field :organization, :type => String
  field :rating, :type => String

  index({ :handle => 1 }, { :unique => true })

  def as_simple_json
    {
      :handle => handle,
      :rating => rating,
    }
  end

end

