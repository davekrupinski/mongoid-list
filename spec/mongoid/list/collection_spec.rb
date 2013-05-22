require "spec_helper"

describe Mongoid::List::Collection do

  describe "#initialization" do

    let(:simple) do
      Simple.create
    end

    let(:collection) do
      Mongoid::List::Collection.new(simple)
    end

    it "should assign simple to :obj" do
      collection.obj.should eq simple
    end

  end


  describe "#count" do

    context "when unscoped" do
      let(:collection) do
        Mongoid::List::Collection.new(Simple.new)
      end

      before do
        5.times do
          Simple.create
        end
      end

      it "should be 5" do
        collection.count.should eq 5
      end

    end

    context "when scoped" do

      before do
        4.times do
          Scoped.create(group: "airplane 1")
        end

        3.times do
          Scoped.create(group: "airplane 2")
        end

      end

      context "group 1" do

        let(:collection) do
          Mongoid::List::Collection.new(Scoped.new(group: "airplane 1"))
        end

        it "should be 4" do
          collection.count.should eq 4
        end

      end

      context "group 2" do

        let(:collection) do
          Mongoid::List::Collection.new(Scoped.new(group: "airplane 2"))
        end

        it "should be 3" do
          collection.count.should eq 3
        end

      end

    end

  end


  describe "#update_positions_in_list!" do

    context "string Ids" do

      let!(:obj1) { Simple.create }
      let!(:obj2) { Simple.create }
      let!(:obj3) { Simple.create }

      before do
        Simple.update_positions_in_list!([obj2.id.to_s, obj1.id.to_s, obj3.id.to_s])
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

    context "unscoped" do

      let!(:obj1) { Simple.create }
      let!(:obj2) { Simple.create }
      let!(:obj3) { Simple.create }

      before do
        Simple.update_positions_in_list!([obj2.id, obj1.id, obj3.id])
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

      let!(:obj1) { Scoped.create(group: "hell's angels") }
      let!(:obj2) { Scoped.create(group: "hell's angels") }
      let!(:obj3) { Scoped.create(group: "hell's angels") }
      let!(:other) { Scoped.create(group: "charlie's angels") }

      before do
        Scoped.update_positions_in_list!([obj3.id, obj2.id, obj1.id])
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
