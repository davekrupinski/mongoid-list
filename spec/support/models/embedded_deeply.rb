class EmbeddedDeeply

  include Mongoid::Document
  include Mongoid::List

  embedded_in :embedded

end
