Mongoid::Relations::Embedded::Many.class_eval do

  def update_positions_in_list!(elements)
    klass.update_positions_in_list!(elements, binding)
  end

end
