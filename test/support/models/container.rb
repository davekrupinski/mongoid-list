class Container
  include Mongoid::Document
  embeds_many :items, class_name: 'Embedded', order: :position
end
