class Embedded
  include Mongoid::Document
  include Mongoid::List
  embedded_in :container
end
