require "spec_helper"

describe Mongoid::List::Collection do

  describe "#initialization" do

    let(:simple) do
      Simple.create
    end

    let(:collection) do
      Mongoid::List::Collection.new(simple)
    end

    it "should assign simple to :doc" do
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

      let!(:doc1) { Simple.create }
      let!(:doc2) { Simple.create }
      let!(:doc3) { Simple.create }

      before do
        Simple.update_positions_in_list!([doc2.id.to_s, doc1.id.to_s, doc3.id.to_s])
      end

      it "should change doc1 from :position of 1 to 2" do
        doc1.position.should eq 1
        doc1.reload.position.should eq 2
      end

      it "should change doc2 from :position of 2 to 1" do
        doc2.position.should eq 2
        doc2.reload.position.should eq 1
      end

      it "should not change doc3 from :position of 3" do
        doc3.position.should eq 3
        doc3.reload.position.should eq 3
      end

    end

    context "string Ids for class using custom Ids" do

      let!(:doc1) { Custom.create(slug: "one") }
      let!(:doc2) { Custom.create(slug: "two") }
      let!(:doc3) { Custom.create(slug: "three") }

      before do
        Custom.update_positions_in_list!([ "two", "one", "three" ])
      end

      it "should change doc1 from :position of 1 to 2" do
        doc1.position.should eq 1
        doc1.reload.position.should eq 2
      end

      it "should change doc2 from :position of 2 to 1" do
        doc2.position.should eq 2
        doc2.reload.position.should eq 1
      end

      it "should not change doc3 from :position of 3" do
        doc3.position.should eq 3
        doc3.reload.position.should eq 3
      end

    end

    context "unscoped" do

      let!(:doc1) { Simple.create }
      let!(:doc2) { Simple.create }
      let!(:doc3) { Simple.create }

      before do
        Simple.update_positions_in_list!([doc2.id, doc1.id, doc3.id])
      end

      it "should change doc1 from :position of 1 to 2" do
        doc1.position.should eq 1
        doc1.reload.position.should eq 2
      end

      it "should change doc2 from :position of 2 to 1" do
        doc2.position.should eq 2
        doc2.reload.position.should eq 1
      end

      it "should not change doc3 from :position of 3" do
        doc3.position.should eq 3
        doc3.reload.position.should eq 3
      end

    end

    context "scoped" do

      let!(:doc1) { Scoped.create(group: "hell's angels") }
      let!(:doc2) { Scoped.create(group: "hell's angels") }
      let!(:doc3) { Scoped.create(group: "hell's angels") }
      let!(:other) { Scoped.create(group: "charlie's angels") }

      before do
        Scoped.update_positions_in_list!([doc3.id, doc2.id, doc1.id])
      end

      it "should change doc1 from :position of 1 to 3" do
        doc1.position.should eq 1
        doc1.reload.position.should eq 3
      end

      it "should not change doc2 from :position of 2" do
        doc2.position.should eq 2
        doc2.reload.position.should eq 2
      end

      it "should change doc3 from :position of 3 to 1" do
        doc3.position.should eq 3
        doc3.reload.position.should eq 1
      end

      it "should not have touched other scoped" do
        other.position.should eq 1
        other.reload.position.should eq 1
      end

    end

  end

end
