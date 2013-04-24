class Container

  include Mongoid::Document

  embeds_many :items, class_name: 'Embedded'#, order: :position
  embeds_many :scoped_items, class_name: 'ScopedEmbedded'#, order: :position

end
