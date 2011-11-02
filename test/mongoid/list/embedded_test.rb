require 'test_helper'

describe Mongoid::List::Embedded do

  describe "#initialization" do

    let :container do
      Container.create
    end

    let :item do
      container.items.create
    end

    let :embedded do
      Mongoid::List::Embedded.new(item)
    end

    should "assign @item to :obj" do
      assert_equal item, embedded.obj
    end

  end



  describe "#count" do

    context "when unscoped" do

      let :container do
        Container.create!
      end

      let :container2 do
        Container.create!
      end

      let :item do
        container.items.build
      end

      let :embedded do
        Mongoid::List::Embedded.new(item)
      end

      setup do
        3.times { container.items.create! }
        2.times { container2.items.create! }
      end

      should "be 3" do
        assert_equal 3, embedded.count
      end

    end


    context "when scoped" do

      let :container do
        Container.create!
      end

      setup do
        3.times { container.scoped_items.create!(group: "alien") }
        2.times { container.scoped_items.create!(group: "aliens") }
      end

      context "group 1" do

        let :item do
          container.scoped_items.build(group: "alien")
        end

        let :embedded do
          Mongoid::List::Embedded.new(item)
        end

        should "be 3" do
          assert_equal 3, embedded.count
        end

      end

      context "group 2" do

        let :item do
          container.scoped_items.build(group: "aliens")
        end

        let :embedded do
          Mongoid::List::Embedded.new(item)
        end

        should "be 2" do
          assert_equal 2, embedded.count
        end

      end

    end

  end


  describe "#update_positions_in_list!" do

    let :container do
      Container.create!
    end

    context "unscoped" do

      setup do
        @obj1 = container.items.create!
        @obj2 = container.items.create!
        @obj3 = container.items.create!
        container.items.update_positions_in_list!([ @obj2.id, @obj1.id, @obj3.id ])
      end

      should "change @obj1 from :position of 1 to 2" do
        assert_equal 1, @obj1.position
        assert_equal 2, @obj1.reload.position
      end

      should "change @obj2 from :position of 2 to 1" do
        assert_equal 2, @obj2.position
        assert_equal 1, @obj2.reload.position
      end

      should "not change @obj3 from :position of 3" do
        assert_equal 3, @obj3.position
        assert_equal 3, @obj3.reload.position
      end

    end

    context "scoped" do

      setup do
        @obj1 = container.scoped_items.create!(group: "hell's angels")
        @obj2 = container.scoped_items.create!(group: "hell's angels")
        @obj3 = container.scoped_items.create!(group: "hell's angels")
        @other = container.scoped_items.create!(group: "charlie's angels")

        container.scoped_items.update_positions_in_list!([ @obj3.id, @obj2.id, @obj1.id ])
      end

      should "change @obj1 from :position of 1 to 3" do
        assert_equal 1, @obj1.position
        assert_equal 3, @obj1.reload.position
      end

      should "not change @obj2 from :position of 2" do
        assert_equal 2, @obj2.position
        assert_equal 2, @obj2.reload.position
      end

      should "change @obj3 from :position of 3 to 1" do
        assert_equal 3, @obj3.position
        assert_equal 1, @obj3.reload.position
      end

      should "not have touched @other scoped" do
        assert_equal 1, @other.position
        assert_equal 1, @other.reload.position
      end

    end

  end

end
