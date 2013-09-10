class Custom
  include Mongoid::Document
  include Mongoid::List
  field :_id,   type: String, default: -> { slug }
  field :slug,  type: String
end
