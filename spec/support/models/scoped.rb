class Scoped

  include Mongoid::Document
  include Mongoid::List

  field :group, type: String
  field :position, type: Integer, scope: :group

end
