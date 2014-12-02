require "spec_helper"

describe Mongoid::List::Embedded do

  describe ".binding_root" do

    subject do
      Mongoid::List::Embedded
    end

    let(:root) do
      Container.create!
    end

    let(:embedded) do
      root.items.create!
    end

    context "w/ Child Embed" do

      it "returns @root" do
        expect(subject.binding_root(root.items)).to eq root
      end

    end

    context "w/ Deeply Embedded" do

      let!(:deeply_embedded) { embedded.items.create! }

      it "returns @root" do
        expect(subject.binding_root(embedded.items)).to eq root
      end

    end

  end


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

    it "should assign item to :doc" do
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

    context "with String Ids" do

      let!(:doc1) { container.items.create! }
      let!(:doc2) { container.items.create! }
      let!(:doc3) { container.items.create! }

      before do
        container.items.update_positions_in_list!([ doc2.id.to_s, doc1.id.to_s, doc3.id.to_s ])
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

      let!(:doc1) { container.items.create! }
      let!(:doc2) { container.items.create! }
      let!(:doc3) { container.items.create! }

      before do
        container.items.update_positions_in_list!([doc2.id, doc1.id, doc3.id])
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

      let!(:doc1) { container.scoped_items.create!(group: "hell's angels") }
      let!(:doc2) { container.scoped_items.create!(group: "hell's angels") }
      let!(:doc3) { container.scoped_items.create!(group: "hell's angels") }
      let!(:other) { container.scoped_items.create!(group: "charlie's angels") }

      before do
        container.scoped_items.update_positions_in_list!([doc3.id, doc2.id, doc1.id])
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
