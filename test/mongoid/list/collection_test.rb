require 'test_helper'

describe Mongoid::List::Collection do

  describe "#initialization" do

    let :simple do
      Simple.create
    end

    let :collection do
      Mongoid::List::Collection.new(simple)
    end

    should "assign @simple to :obj" do
      assert_equal simple, collection.obj
    end

  end



  describe "#count" do

    context "when unscoped" do

      let :collection do
        Mongoid::List::Collection.new(Simple.new)
      end

      setup do
        5.times { Simple.create }
      end

      should "be 5" do
        assert_equal 5, collection.count
      end

    end


    context "when scoped" do

      setup do
        4.times { Scoped.create(group: "airplane 1") }
        3.times { Scoped.create(group: "airplane 2") }
      end

      context "group 1" do

        let :collection do
          Mongoid::List::Collection.new(Scoped.new(group: "airplane 1"))
        end

        should "be 4" do
          assert_equal 4, collection.count
        end

      end

      context "group 2" do

        let :collection do
          Mongoid::List::Collection.new(Scoped.new(group: "airplane 2"))
        end

        should "be 3" do
          assert_equal 3, collection.count
        end

      end

    end

  end


  describe "#update_positions_in_list!" do

    context "unscoped" do

      setup do
        @obj1 = Simple.create
        @obj2 = Simple.create
        @obj3 = Simple.create
        Simple.update_positions_in_list!([ @obj2.id, @obj1.id, @obj3.id ])
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
        @obj1 = Scoped.create(group: "hell's angels")
        @obj2 = Scoped.create(group: "hell's angels")
        @obj3 = Scoped.create(group: "hell's angels")
        @other = Scoped.create(group: "charlie's angels")

        Scoped.update_positions_in_list!([ @obj3.id, @obj2.id, @obj1.id ])
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
