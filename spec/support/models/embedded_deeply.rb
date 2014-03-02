class EmbeddedDeeply

  include Mongoid::Document
  include Mongoid::List

  lists

  embedded_in :embedded

end
