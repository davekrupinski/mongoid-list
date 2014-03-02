class Scoped

  include Mongoid::Document
  include Mongoid::List

  field :group, type: String
  lists scope: :group

end
