class Scoped

  include Mongoid::Document
  include Mongoid::List

  field :group, type: String
  field :position, scope: :group

end
