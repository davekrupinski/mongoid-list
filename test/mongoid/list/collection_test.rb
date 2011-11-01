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


end
