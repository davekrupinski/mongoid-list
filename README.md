Mongoid List
============

Mongoid List uses a position column to maintain an ordered list, with optional scoping.  It uses atomic updates to keep lists in either a Collection or Embedded in sync.

Starting with version 0.7.0, Mongoid 5+ is required. If you want Mongoid 4 support use the 0.6.0 version of this gem.

Installation
------------

Add to your Gemfile:

```ruby
gem 'mongoid-list'
```

Usage
-----

Add a list:

```ruby
class CrowTRobot
  include Mongoid::Document
  include Mongoid::List

  lists

end
```


Available methods:

```ruby

# Update Position

doc1.position  # => 1
doc2.position  # => 2

doc1.position = 2
doc1.save

doc1.position  # => 2
doc2.position  # => 1


# Reorder a Full List
Klass.update_positions_in_list!(elements)

Pass in all elements in new ordering.  Accepts documents or ids.

# Scope Information
doc.list_scoped?  		# If scoping has been defined
doc.list_scope_field		# Which field to scope against
doc.list_scope_value		# Value of the scoping field
doc.list_scope_conditions	# Additional query conditions for scoped lists.

```


Scoping
-------

To scope the list, pass `:scope` on lists definition:

```ruby
class TomServo
  include Mongoid::Document
  include Mongoid::List

  lists scope: :satellite_of_love_id
  belongs_to :satellite_of_love

end
```

TO-DO
-------
* Helper methods to move individual documents within the list.
* Customizable filed name.

