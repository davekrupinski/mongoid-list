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


end
