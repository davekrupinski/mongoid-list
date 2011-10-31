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


end

