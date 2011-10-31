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



  describe "Updating Position" do

    context "for Collection List" do

      setup do
        @group1_1 = Scoped.create(group: 1)
        @group1_2 = Scoped.create(group: 1)
        @group2_1 = Scoped.create(group: 2)
        @group2_2 = Scoped.create(group: 2)
        @group2_3 = Scoped.create(group: 3)
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

    end

  end



end
