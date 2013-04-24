class Embedded

  include Mongoid::Document
  include Mongoid::List

  embedded_in :container
  embeds_many :items, class_name: 'EmbeddedDeeply'

end
