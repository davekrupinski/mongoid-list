require "spec_helper"

describe Mongoid::List::Embedded do

  describe "#initialization" do

    let(:container) do
      Container.create
    end

    let(:item) do
      container.items.create
    end

    let(:embedded) do
      Mongoid::List::Embedded.new(item)
    end

    it "should assign item to :obj" do
      embedded.obj.should eq item
    end

  end


  describe "#count" do

    context "when unscoped" do

      let(:container) do
        Container.create!
      end

      let(:container2) do
        Container.create!
      end

      let(:item) do
        container.items.build
      end

      let(:embedded) do
        Mongoid::List::Embedded.new(item)
      end

      before do
        3.times do
          container.items.create!
        end
        2.times do
          container2.items.create!
        end
      end

      it "should be 3" do
        embedded.count.should eq 3
      end

    end

    context "when scoped" do

      let(:container) do
        Container.create!
      end

      before do
        3.times do
          container.scoped_items.create!(group: "alien")
        end
        2.times do
          container.scoped_items.create!(group: "aliens")
        end
      end

      context "group 1" do

        let(:item) do
          container.scoped_items.build(group: "alien")
        end

        let(:embedded) do
          Mongoid::List::Embedded.new(item)
        end

        it "should be 3" do
          embedded.count.should eq 3
        end

      end

      context "group 2" do

        let(:item) do
          container.scoped_items.build(group: "aliens")
        end

        let(:embedded) do
          Mongoid::List::Embedded.new(item)
        end

        it "should be 2" do
          embedded.count.should eq 2
        end

      end

    end

  end


  describe "#update_positions_in_list!" do

    let(:container) do
      Container.create!
    end

    context "unscoped" do

      let!(:obj1) { container.items.create! }
      let!(:obj2) { container.items.create! }
      let!(:obj3) { container.items.create! }

      before do
        container.items.update_positions_in_list!([obj2.id, obj1.id, obj3.id])
      end

      it "should change obj1 from :position of 1 to 2" do
        obj1.position.should eq 1
        obj1.reload.position.should eq 2
      end

      it "should change obj2 from :position of 2 to 1" do
        obj2.position.should eq 2
        obj2.reload.position.should eq 1
      end

      it "should not change obj3 from :position of 3" do
        obj3.position.should eq 3
        obj3.reload.position.should eq 3
      end

    end

    context "scoped" do

      let!(:obj1) { container.scoped_items.create!(group: "hell's angels") }
      let!(:obj2) { container.scoped_items.create!(group: "hell's angels") }
      let!(:obj3) { container.scoped_items.create!(group: "hell's angels") }
      let!(:other) { container.scoped_items.create!(group: "charlie's angels") }

      before do
        container.scoped_items.update_positions_in_list!([obj3.id, obj2.id, obj1.id])
      end

      it "should change obj1 from :position of 1 to 3" do
        obj1.position.should eq 1
        obj1.reload.position.should eq 3
      end

      it "should not change obj2 from :position of 2" do
        obj2.position.should eq 2
        obj2.reload.position.should eq 2
      end

      it "should change obj3 from :position of 3 to 1" do
        obj3.position.should eq 3
        obj3.reload.position.should eq 1
      end

      it "should not have touched other scoped" do
        other.position.should eq 1
        other.reload.position.should eq 1
      end

    end

  end

end
