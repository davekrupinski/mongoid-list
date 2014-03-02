class Embedded

  include Mongoid::Document
  include Mongoid::List

  lists

  embedded_in :container
  embeds_many :items, class_name: 'EmbeddedDeeply'

end
