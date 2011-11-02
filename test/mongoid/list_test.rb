require 'test_helper'


describe Mongoid::List do


  context "Setting Initial Position" do
    setup do
      @list1 = Simple.create
      @list2 = Simple.create
    end

    should "have set @list1's position to 1" do
      assert_equal 1, @list1.position
    end

    should "have set @list2's position to 2" do
      assert_equal 2, @list2.position
    end
  end



  context "Setting Initial Position in Embedded Collection" do
    setup do
      @container = Container.create
      @list1 = @container.items.create
      @list2 = @container.items.create
      @list3 = @container.items.create
      @unrelated_list = Container.create.items.create
    end

    should "have created the container" do
      assert_equal 3, @container.items.count
    end


    should "have set the initial positions for each list item" do
      assert_equal 1, @list1.position
      assert_equal 2, @list2.position
      assert_equal 3, @list3.position
    end

    should "have also set the @unrelated_list's position independently" do
      assert_equal 1, @unrelated_list.position
    end
  end



  context "Updating List Position" do
    setup do
      @list1 = Simple.create
      @list2 = Simple.create
      @list3 = Simple.create
      @list4 = Simple.create
    end

    should "have set initial positions" do
      assert_equal 1, @list1.position
      assert_equal 2, @list2.position
      assert_equal 3, @list3.position
      assert_equal 4, @list4.position
    end

    context "for @list2 going to position of 1" do
      setup do
        @list2.update_attributes(:position => 1)
        @list1.reload; @list2.reload; @list3.reload; @list4.reload
      end

      should "have updated everyone's :position" do
        assert_equal 2, @list1.position
        assert_equal 1, @list2.position
        assert_equal 3, @list3.position
        assert_equal 4, @list4.position
      end
    end

    context "for @list3 going to position of 1" do
      setup do
        @list3.update_attributes(:position => 1)
        @list1.reload; @list2.reload; @list3.reload; @list4.reload
      end

      should "have updated everyone's :position" do
        assert_equal 2, @list1.position
        assert_equal 3, @list2.position
        assert_equal 1, @list3.position
        assert_equal 4, @list4.position
      end
    end

    context "for @list1 going to position of 2" do
      setup do
        @list1.update_attributes(:position => 2)
        @list1.reload; @list2.reload; @list3.reload; @list4.reload
      end

      should "have updated everyone's :position" do
        assert_equal 2, @list1.position
        assert_equal 1, @list2.position
        assert_equal 3, @list3.position
        assert_equal 4, @list4.position
      end
    end

    context "for @list1 going to position of 3" do
      setup do
        @list1.update_attributes(:position => 3)
        @list1.reload; @list2.reload; @list3.reload; @list4.reload
      end

      should "have updated everyone's :position" do
        assert_equal 3, @list1.position
        assert_equal 1, @list2.position
        assert_equal 2, @list3.position
        assert_equal 4, @list4.position
      end
    end
  end



  context "Updating List Position in Embedded Collection" do
    setup do
      @container = Container.create
      @list1 = @container.items.create
      @list2 = @container.items.create
      @list3 = @container.items.create
      @list4 = @container.items.create
    end

    should "have set initial positions" do
      assert_equal 1, @list1.position
      assert_equal 2, @list2.position
      assert_equal 3, @list3.position
      assert_equal 4, @list4.position
    end

    context "for @list2 going to position of 1" do
      setup do
        @list2.update_attributes(:position => 1)
        @container.reload
      end

      should "have updated everyone's :position" do
        assert_equal 2, @container.items.find(@list1.id).position
        assert_equal 1, @container.items.find(@list2.id).position
        assert_equal 3, @container.items.find(@list3.id).position
        assert_equal 4, @container.items.find(@list4.id).position
      end
    end

    context "for @list3 going to position of 1" do
      setup do
        @list3.update_attributes(:position => 1)
        @container.reload
      end

      should "have updated everyone's :position" do
        assert_equal 2, @container.items.find(@list1.id).position
        assert_equal 3, @container.items.find(@list2.id).position
        assert_equal 1, @container.items.find(@list3.id).position
        assert_equal 4, @container.items.find(@list4.id).position
      end
    end

    context "for @list1 going to position of 2" do
      setup do
        @list1.update_attributes(:position => 2)
        @container.reload
      end

      should "have updated everyone's :position" do
        assert_equal 2, @container.items.find(@list1.id).position
        assert_equal 1, @container.items.find(@list2.id).position
        assert_equal 3, @container.items.find(@list3.id).position
        assert_equal 4, @container.items.find(@list4.id).position
      end
    end

    context "for @list1 going to position of 3" do
      setup do
        @list1.update_attributes(:position => 3)
        @container.reload
      end

      should "have updated everyone's :position" do
        assert_equal 3, @container.items.find(@list1.id).position
        assert_equal 1, @container.items.find(@list2.id).position
        assert_equal 2, @container.items.find(@list3.id).position
        assert_equal 4, @container.items.find(@list4.id).position
      end
    end
  end



  context "Removing an Item from a List" do
    setup do
      @list1 = Simple.create
      @list2 = Simple.create
      @list3 = Simple.create
      @list4 = Simple.create
    end

    context "from the first position" do
      setup do
        @list1.destroy
        @list2.reload; @list3.reload; @list4.reload
      end

      should "have moved all other items up" do
        assert_equal 1, @list2.position
        assert_equal 2, @list3.position
        assert_equal 3, @list4.position
      end
    end

    context "removing from the 2nd position" do
      setup do
        @list2.destroy
        @list1.reload; @list3.reload; @list4.reload
      end

      should "have kept @list1 where it was" do
        assert_equal 1, @list1.position
      end

      should "have moved lower items up" do
        assert_equal 2, @list3.position
        assert_equal 3, @list4.position
      end
    end

    context "removing from the 4th and last position" do
      setup do
        @list4.destroy
        @list1.reload; @list2.reload; @list3.reload
      end

      should "have kept everything else where it was" do
        assert_equal 1, @list1.position
        assert_equal 2, @list2.position
        assert_equal 3, @list3.position
      end
    end
  end



  context "Removing an Item from an Embedded List" do
    setup do
      @container = Container.create
      @list1 = @container.items.create
      @list2 = @container.items.create
      @list3 = @container.items.create
      @list4 = @container.items.create
    end

    context "from the first position" do
      setup do
        @list1.destroy
        @container.reload
      end

      should "have moved all other items up" do
        assert_equal 1, @container.items.find(@list2.id).position
        assert_equal 2, @container.items.find(@list3.id).position
        assert_equal 3, @container.items.find(@list4.id).position
      end
    end

    context "removing from the 2nd position" do
      setup do
        @list2.destroy
        @container.reload
      end

      should "have kept @list1 where it was" do
        assert_equal 1, @container.items.find(@list1.id).position
      end

      should "have moved lower items up" do
        assert_equal 2, @container.items.find(@list3.id).position
        assert_equal 3, @container.items.find(@list4.id).position
      end
    end

    context "removing from the 4th and last position" do
      setup do
        @list4.destroy
        @container.reload
      end

      should "have kept everything else where it was" do
        assert_equal 1, @container.items.find(@list1.id).position
        assert_equal 2, @container.items.find(@list2.id).position
        assert_equal 3, @container.items.find(@list3.id).position
      end
    end
  end



  context "#list_scoped?" do


    context "for Simple (unscoped)" do

      let(:obj) do
        Simple.new
      end

      should "be nil" do
        assert !obj.list_scoped? 
      end

    end


    context "for Scoped" do

      let(:obj) do
        Scoped.new
      end

      should "be :group" do
        assert obj.list_scoped?
      end

    end

  end




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



  describe "#update_positions_in_list!" do

    context "on a Collection" do

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

    context "on an Embedded Collection" do

      let :container do
        Container.create!
      end

      setup do
        @obj1 = container.items.create!
        @obj2 = container.items.create!
        @obj3 = container.items.create!
        @obj4 = container.items.create!
        container.items.update_positions_in_list!([ @obj2.id, @obj1.id, @obj4.id, @obj3.id ])
      end

      should "change @obj1 from :position of 1 to 2" do
        assert_equal 1, @obj1.position
        assert_equal 2, @obj1.reload.position
      end

    end

  end

end
