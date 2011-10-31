require 'test_helper'

describe Mongoid::List::Scoping do

  describe "#list_scope_field" do

    let :obj do
      Scoped.create
    end

    should "be :group" do
      assert_equal :group, obj.list_scope_field
    end

  end


  describe "#list_scope_conditions" do

    context "when unscoped" do

      let :obj do
        Simple.new
      end

      let :expected_conditions do
        { }
      end

      should "be an empty hash" do
        assert_equal expected_conditions, obj.list_scope_conditions
      end

    end

    context "when scoped" do

      let :obj do
        Scoped.new(group: "a grouping")
      end

      let :expected_conditions do
        { group: "a grouping" }
      end

      should "have be for a :group of 'a grouping'" do
        assert_equal expected_conditions, obj.list_scope_conditions
      end
    end

  end


  describe "Initializing in multiple scopes" do

    context "on a Collection" do

      setup do
        @group1_1 = Scoped.create(group: 1)
        @group2_1 = Scoped.create(group: 2)
        @group2_2 = Scoped.create(group: 2)
      end

      should "default @group1_1 to a :position of 1" do
        assert_equal 1, @group1_1.position
      end

      should "default @group2_1 to a :position of 1" do
        assert_equal 1, @group2_1.position
      end

      should "default @group2_2 to a :position of 2" do
        assert_equal 2, @group2_2.position
      end

    end

    context "on Embedded Documents" do

      setup do
        @container = Container.create
        @group1_1 = @container.scoped_items.create(group: 1)
        @group1_2 = @container.scoped_items.create(group: 1)
        @group2_1 = @container.scoped_items.create(group: 2)
        @group2_2 = @container.scoped_items.create(group: 2)
        @group2_3 = @container.scoped_items.create(group: 2)
        @group3_1 = @container.scoped_items.create(group: 3)
      end

      should "default @group1_1 to a :position of 1" do
        assert_equal 1, @group1_1.position
      end

      should "default @group1_2 to a :position of 2" do
        assert_equal 2, @group1_2.position
      end

      should "default @group2_1 to a :position of 1" do
        assert_equal 1, @group2_1.position
      end

      should "default @group2_2 to a :position of 2" do
        assert_equal 2, @group2_2.position
      end

      should "default @group2_3 to a :position of 3" do
        assert_equal 3, @group2_3.position
      end

      should "default @group3_1 to a :position of 1" do
        assert_equal 1, @group3_1.position
      end

    end
  end



  describe "#update :position" do

    context "for Collection List" do

      setup do
        @group1_1 = Scoped.create(group: 1)
        @group1_2 = Scoped.create(group: 1)
        @group2_1 = Scoped.create(group: 2)
        @group2_2 = Scoped.create(group: 2)
        @group2_3 = Scoped.create(group: 2)
      end

      context "@group1_2 to :position 1" do

        setup do
          @group1_2.update_attribute(:position, 1)
        end

        should "have updated @group1_1 to :position of 2" do
          assert_equal 1, @group1_1.position
          assert_equal 2, @group1_1.reload.position
        end

        should "not have updated :group2_1's :position" do
          assert_equal @group2_1.position, @group2_1.reload.position
        end

        should "not have updated :group2_2's :position" do
          assert_equal @group2_2.position, @group2_2.reload.position
        end

        should "not have updated :group2_3's :position" do
          assert_equal @group2_3.position, @group2_3.reload.position
        end

      end


      context "@group2_2 to :position 3" do

        setup do
          @group2_2.update_attribute(:position, 3)
        end

        should "not have updated @group1_1's :position" do
          assert_equal @group1_1.position, @group1_1.reload.position
        end

        should "not have updated @group1_2's :position" do
          assert_equal @group1_2.position, @group1_2.reload.position
        end

        should "not have updated @group2_1's :position" do
          assert_equal @group2_1.position, @group2_1.reload.position
        end

        should "have updated @group2_2's :position to 3" do
          assert_equal 3, @group2_2.position
        end

        should "have updated @group2_3's :position to 2" do
          assert_equal 3, @group2_3.position
          assert_equal 2, @group2_3.reload.position
        end
      end

    end


    context "for an Embedded List" do

      setup do
        @container = Container.create
        @group1_1 = @container.scoped_items.create(group: 1)
        @group1_2 = @container.scoped_items.create(group: 1)
        @group2_1 = @container.scoped_items.create(group: 2)
        @group2_2 = @container.scoped_items.create(group: 2)
        @group2_3 = @container.scoped_items.create(group: 2)
      end

      context "moving @group1_1 to :position 2" do

        setup do
          @group1_1.update_attributes(position: 2)
        end

        should "update @group1_1's :position to 2" do
          assert_equal 2, @group1_1.position
        end

        should "update @group1_2's :position to 1" do
          assert_equal 2, @group1_2.position
          assert_equal 1, @group1_2.reload.position
        end

        should "not update @group2_1's :position" do
          assert_equal 1, @group2_1.position
          assert_equal 1, @group2_1.reload.position
        end

        should "not update @group2_2's :position" do
          assert_equal 2, @group2_2.position
          assert_equal 2, @group2_2.reload.position
        end

        should "not update @group2_3's :position" do
          assert_equal 3, @group2_3.position
          assert_equal 3, @group2_3.reload.position
        end
      end


      context "moving @group2_3 to :position 1" do

        setup do
          @group2_3.update_attributes(position: 1)
        end

        should "not update @group1_1's :position" do
          assert_equal 1, @group1_1.position
          assert_equal 1, @group1_1.reload.position
        end

        should "not update @group1_2's :position" do
          assert_equal 2, @group1_2.position
          assert_equal 2, @group1_2.reload.position
        end

        should "update @group2_1's :position to 2" do
          assert_equal 1, @group2_1.position
          assert_equal 2, @group2_1.reload.position
        end

        should "update @group2_2's :position to 3" do
          assert_equal 2, @group2_2.position
          assert_equal 3, @group2_2.reload.position
        end

        should "update @group2_3's :position to 1" do
          assert_equal 1, @group2_3.position
          assert_equal 1, @group2_3.reload.position
        end
      end

    end

  end



  describe "#destroy" do

    context "from a Collection" do

      setup do
        @group1_1 = Scoped.create(group: 1)
        @group1_2 = Scoped.create(group: 1)
        @group2_1 = Scoped.create(group: 2)
        @group2_2 = Scoped.create(group: 2)
        @group2_3 = Scoped.create(group: 2)
      end

      context "for @group2_1" do

        setup do
          @group2_1.destroy
        end

        should "not update @group1_1's :position" do
          assert_equal 1, @group1_1.position
          assert_equal 1, @group1_1.reload.position
        end

        should "not update @group1_2's :position" do
          assert_equal 2, @group1_2.position
          assert_equal 2, @group1_2.reload.position
        end

        should "update @group2_2's :position to 1" do
          assert_equal 2, @group2_2.position
          assert_equal 1, @group2_2.reload.position
        end

        should "update @group2_3's :position to 2" do
          assert_equal 3, @group2_3.position
          assert_equal 2, @group2_3.reload.position
        end
      end

    end


    context "from an Embedded Collection" do

      setup do
        @container = Container.create
        @group1_1 = @container.scoped_items.create(group: 1)
        @group1_2 = @container.scoped_items.create(group: 1)
        @group2_1 = @container.scoped_items.create(group: 2)
        @group2_2 = @container.scoped_items.create(group: 2)
        @group2_3 = @container.scoped_items.create(group: 2)
      end

      context "for @group2_2" do

        setup do
          @group2_2.destroy
        end

        should "not update @group1_1's :position" do
          assert_equal 1, @group1_1.position
          assert_equal 1, @group1_1.reload.position
        end

        should "not update @group1_2's :position" do
          assert_equal 2, @group1_2.position
          assert_equal 2, @group1_2.reload.position
        end

        should "not update @group2_1's :position" do
          assert_equal 1, @group2_1.position
          assert_equal 1, @group2_1.reload.position
        end

        should "update @group2_3's :position to 2" do
          assert_equal 3, @group2_3.position
          assert_equal 2, @container.reload.scoped_items.find(@group2_3.id).position
        end
      end

    end


  end

end
