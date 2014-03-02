class ScopedEmbedded

  include Mongoid::Document
  include Mongoid::List

  embedded_in :container

  field :group, type: String
  # field :position, type: Integer, scope: :group

  lists scope: :group

end
