require "spec_helper"

describe Mongoid::List do

  describe "Creation" do

    context "simple" do

      let!(:list1) { Simple.create }
      let!(:list2) { Simple.create }

      it "should have set list1's position to 1" do
        list1.position.should eq 1
      end

      it "should have set list2's position to 2" do
        list2.position.should eq 2
      end

    end

    context "in embedded collection" do

      let!(:container) { Container.create }
      let!(:list1) { container.items.create }
      let!(:list2) { container.items.create }
      let!(:list3) { container.items.create }
      let!(:unrelated_list) { Container.create.items.create }

      it "should have created the container" do
        container.items.count.should eq 3
      end

      it "should have set the initial positions for each list item" do
        list1.position.should eq 1
        list2.position.should eq 2
        list3.position.should eq 3
      end

      it "should have also set the unrelated_list's position independently" do
        unrelated_list.position.should eq 1
      end

    end

  end


  describe "Updating" do

    let!(:list1) { Simple.create }
    let!(:list2) { Simple.create }
    let!(:list3) { Simple.create }
    let!(:list4) { Simple.create }

    it "should have set initial positions" do
      list1.position.should eq 1
      list2.position.should eq 2
      list3.position.should eq 3
      list4.position.should eq 4
    end

    context "for @list2 going to position of 1" do

      before do
        list2.update_attributes(position: 1)
        list1.reload
        list2.reload
        list3.reload
        list4.reload
      end

      it "should have updated everyone's :position" do
        list1.position.should eq 2
        list2.position.should eq 1
        list3.position.should eq 3
        list4.position.should eq 4
      end

    end

    context "for list3 going to position of 1" do

      before do
        list3.update_attributes(position: 1)
        list1.reload
        list2.reload
        list3.reload
        list4.reload
      end

      it "should have updated everyone's :position" do
        list1.position.should eq 2
        list2.position.should eq 3
        list3.position.should eq 1
        list4.position.should eq 4
      end

    end

    context "for list1 going to position of 2" do

      before do
        list1.update_attributes(position: 2)
        list1.reload
        list2.reload
        list3.reload
        list4.reload
      end

      it "should have updated everyone's :position" do
        list1.position.should eq 2
        list2.position.should eq 1
        list3.position.should eq 3
        list4.position.should eq 4
      end

    end

    context "for list1 going to position of 3" do

      before do
        list1.update_attributes(position: 3)
        list1.reload
        list2.reload
        list3.reload
        list4.reload
      end

      it "should have updated everyone's :position" do
        list1.position.should eq 3
        list2.position.should eq 1
        list3.position.should eq 2
        list4.position.should eq 4
      end

    end

  end


  describe "Updating Embedded" do

    let!(:container) { Container.create }
    let!(:list1) { container.items.create }
    let!(:list2) { container.items.create }
    let!(:list3) { container.items.create }
    let!(:list4) { container.items.create }

    it "should have set initial positions" do
      list1.position.should eq 1
      list2.position.should eq 2
      list3.position.should eq 3
      list4.position.should eq 4
    end

    context "for list2 going to position of 1" do

      before do
        list2.update_attributes(position: 1)
        container.reload
      end

      it "should have updated everyone's :position" do
        container.items.find(list1.id).position.should eq 2
        container.items.find(list2.id).position.should eq 1
        container.items.find(list3.id).position.should eq 3
        container.items.find(list4.id).position.should eq 4
      end

    end

    context "for list3 going to position of 1" do

      before do
        list3.update_attributes(position: 1)
        container.reload
      end

      it "should have updated everyone's :position" do
        container.items.find(list1.id).position.should eq 2
        container.items.find(list2.id).position.should eq 3
        container.items.find(list3.id).position.should eq 1
        container.items.find(list4.id).position.should eq 4
      end

    end

    context "for list1 going to position of 2" do

      before do
        list1.update_attributes(position: 2)
        container.reload
      end

      it "should have updated everyone's :position" do
        container.items.find(list1.id).position.should eq 2
        container.items.find(list2.id).position.should eq 1
        container.items.find(list3.id).position.should eq 3
        container.items.find(list4.id).position.should eq 4
      end

    end

    context "for list1 going to position of 3" do

      before do
        list1.update_attributes(position: 3)
        container.reload
      end

      it "should have updated everyone's :position" do
        container.items.find(list1.id).position.should eq 3
        container.items.find(list2.id).position.should eq 1
        container.items.find(list3.id).position.should eq 2
        container.items.find(list4.id).position.should eq 4
      end

    end

  end


  context "#destroy" do

    let!(:list1) { Simple.create }
    let!(:list2) { Simple.create }
    let!(:list3) { Simple.create }
    let!(:list4) { Simple.create }

    context "from the first position" do

      before do
        list1.destroy
        list2.reload
        list3.reload
        list4.reload
      end

      it "should have moved all other items up" do
        list2.position.should eq 1
        list3.position.should eq 2
        list4.position.should eq 3
      end

    end

    context "removing from the 2nd position" do

      before do
        list2.destroy
        list1.reload
        list3.reload
        list4.reload
      end

      it "should have kept list1 where it was" do
        list1.position.should eq 1
      end

      it "should have moved lower items up" do
        list3.position.should eq 2
        list4.position.should eq 3
      end

    end

    context "removing from the 4th and last position" do

      before do
        list4.destroy
        list1.reload
        list2.reload
        list3.reload
      end

      it "should have kept everything else where it was" do
        list1.position.should eq 1
        list2.position.should eq 2
        list3.position.should eq 3
      end

    end

  end


  context "#destroy in Embedded" do

    let!(:container) { Container.create }
    let!(:list1) { container.items.create }
    let!(:list2) { container.items.create }
    let!(:list3) { container.items.create }
    let!(:list4) { container.items.create }

    context "from the first position" do

      before do
        list1.destroy
        container.reload
      end

      it "should have moved all other items up" do
        container.items.find(list2.id).position.should eq 1
        container.items.find(list3.id).position.should eq 2
        container.items.find(list4.id).position.should eq 3
      end

    end

    context "removing from the 2nd position" do

      before do
        list2.destroy
        container.reload
      end

      it "should have kept list1 where it was" do
        container.items.find(list1.id).position.should eq 1
      end

      it "should have moved list3 up to :position 2" do
        container.items.find(list3.id).position.should eq 2
      end

      it "should have moved list4 up to :position 3" do
        container.items.find(list4.id).position.should eq 3
      end

    end

    context "removing from the 4th and last position" do

      before do
        list4.destroy
        container.reload
      end

      it "should have kept everything else where it was" do
        container.items.find(list1.id).position.should eq 1
        container.items.find(list2.id).position.should eq 2
        container.items.find(list3.id).position.should eq 3
      end

    end

  end

  context "#destroy Item from Deeply Embedded List" do

    let!(:container) { Container.create }
    let!(:list) { container.items.create }
    let!(:item1) { list.items.create }
    let!(:item2) { list.items.create }
    let!(:item3) { list.items.create }

    context "from 1st position" do

      before do
        item1.destroy
        container.reload
      end

      it "should have moved all other items up" do
        container.items.first.items.find(item2.id).position.should eq 1
        container.items.first.items.find(item3.id).position.should eq 2
      end

    end

    context "from middle position" do

      before do
        item2.destroy
        container.reload
      end

      it "should have moved last items up" do
        container.items.first.items.find(item1.id).position.should eq 1
        container.items.first.items.find(item3.id).position.should eq 2
      end

    end

  end


  describe "#list_scoped?" do

    context "for Simple (unscoped)" do

      subject { Simple.new }
      it { should_not be_list_scoped }

    end

    context "for Scoped" do

      subject { Scoped.new }
      it { should be_list_scoped }

    end

  end


  describe "#list_scope_field" do

    subject { Scoped.create }

    it "should be :group" do
      subject.list_scope_field.should eq :group
    end

  end


  describe "#list_scope_conditions" do

    context "when unscoped" do

      subject { Simple.new }

      let(:expected_conditions) do
        {}
      end

      it "should be an empty hash" do
        subject.list_scope_conditions.should eq expected_conditions
      end

    end

    context "when scoped" do

      subject { Scoped.new(group: "a grouping") }

      let(:expected_conditions) do
        { group: "a grouping" }
      end

      it "should have be for a :group of 'a grouping'" do
        subject.list_scope_conditions.should eq expected_conditions
      end

    end

  end


  describe "#list_scope_changing_conditions" do

    subject { Scoped.new }

    it "uses value in :_scope_list_update_to_previous" do
      subject._scope_list_update_to_previous = "this-is-something-eh"
      subject.list_scope_changing_conditions.should eq \
        ({ group: "this-is-something-eh" })
    end

  end


  describe "#list_scope_changing?" do

    context "when unscoped" do

      subject { Simple.create }
      specify { subject.list_scope_changing?.should be_false }

    end

    context "when Scoped" do

      subject { Scoped.create(group: "A") }

      context "but no change to :group" do

        specify { subject.list_scope_changing?.should be_false }

      end

      context "with change to :group" do

        before  { subject.group = "B" }
        specify { subject.list_scope_changing?.should be_true }

      end

    end

  end


  describe "Initializing in multiple scopes" do

    context "on a Collection" do

      let!(:group1_1) { Scoped.create(group: 1) }
      let!(:group2_1) { Scoped.create(group: 2) }
      let!(:group2_2) { Scoped.create(group: 2) }

      it "should default group1_1 to a :position of 1" do
        group1_1.position.should eq 1
      end

      it "should default group2_1 to a :position of 1" do
        group2_1.position.should eq 1
      end

      it "should default group2_2 to a :position of 2" do
        group2_2.position.should eq 2
      end
    end

    context "on Embedded Documents" do

      let!(:container) { Container.create }
      let!(:group1_1) { container.scoped_items.create(group: 1) }
      let!(:group1_2) { container.scoped_items.create(group: 1) }
      let!(:group2_1) { container.scoped_items.create(group: 2) }
      let!(:group2_2) { container.scoped_items.create(group: 2) }
      let!(:group2_3) { container.scoped_items.create(group: 2) }
      let!(:group3_1) { container.scoped_items.create(group: 3) }

      it "should default group1_1 to a :position of 1" do
        group1_1.position.should eq 1
      end

      it "should default group1_2 to a :position of 2" do
        group1_2.position.should eq 2
      end

      it "should default group2_1 to a :position of 1" do
        group2_1.position.should eq 1
      end

      it "should default group2_2 to a :position of 2" do
        group2_2.position.should eq 2
      end

      it "should default group2_3 to a :position of 3" do
        group2_3.position.should eq 3
      end

      it "should default group3_1 to a :position of 1" do
        group3_1.position.should eq 1
      end

    end

  end


  describe "#update :position" do

    context "for Collection List" do

      let!(:group1_1) { Scoped.create(group: 1) }
      let!(:group1_2) { Scoped.create(group: 1) }
      let!(:group2_1) { Scoped.create(group: 2) }
      let!(:group2_2) { Scoped.create(group: 2) }
      let!(:group2_3) { Scoped.create(group: 2) }

      context "group1_2 to :position 1" do

        before do
          group1_2.update_attribute(:position, 1)
        end

        it "should have updated group1_1 to :position of 2" do
          group1_1.position.should eq 1
          group1_1.reload.position.should eq 2
        end

        it "should not have updated :group2_1's :position" do
          group2_1.reload.position.should eq group2_1.position
        end

        it "should not have updated :group2_2's :position" do
          group2_2.reload.position.should eq group2_2.position
        end

        it "should not have updated :group2_3's :position" do
          group2_3.reload.position.should eq group2_3.position
        end

      end

      context "group2_2 to :position 3" do

        before do
          group2_2.update_attribute(:position, 3)
        end

        it "should not have updated group1_1's :position" do
          group1_1.reload.position.should eq group1_1.position
        end

        it "should not have updated group1_2's :position" do
          group1_2.reload.position.should eq group1_2.position
        end

        it "should not have updated group2_1's :position" do
          group2_1.reload.position.should eq group2_1.position
        end

        it "should have updated group2_2's :position to 3" do
          group2_2.position.should eq 3
        end

        it "should have updated group2_3's :position to 2" do
          group2_3.position.should eq 3
          group2_3.reload.position.should eq 2
        end

      end

    end

    context "for an Embedded List" do

      let!(:container) { Container.create }
      let!(:group1_1) { container.scoped_items.create(group: 1) }
      let!(:group1_2) { container.scoped_items.create(group: 1) }
      let!(:group2_1) { container.scoped_items.create(group: 2) }
      let!(:group2_2) { container.scoped_items.create(group: 2) }
      let!(:group2_3) { container.scoped_items.create(group: 2) }

      context "moving group1_1 to :position 2" do

        before do
          group1_1.update_attributes(position: 2)
        end

        it "should update group1_1's :position to 2" do
          group1_1.position.should eq 2
        end

        it "should update group1_2's :position to 1" do
          group1_2.position.should eq 2
          group1_2.reload.position.should eq 1
        end

        it "should not update group2_1's :position" do
          group2_1.position.should eq 1
          group2_1.reload.position.should eq 1
        end

        it "should not update group2_2's :position" do
          group2_2.position.should eq 2
          group2_2.reload.position.should eq 2
        end

        it "should not update group2_3's :position" do
          group2_3.position.should eq 3
          group2_3.reload.position.should eq 3
        end

      end

      context "moving group2_3 to :position 1" do

        before do
          group2_3.update_attributes(position: 1)
        end

        it "should not update group1_1's :position" do
          group1_1.position.should eq 1
          group1_1.reload.position.should eq 1
        end

        it "should not update group1_2's :position" do
          group1_2.position.should eq 2
          group1_2.reload.position.should eq 2
        end

        it "should update group2_1's :position to 2" do
          group2_1.position.should eq 1
          group2_1.reload.position.should eq 2
        end

        it "should update group2_2's :position to 3" do
          group2_2.position.should eq 2
          group2_2.reload.position.should eq 3
        end

        it "should update group2_3's :position to 1" do
          group2_3.position.should eq 1
          group2_3.reload.position.should eq 1
        end

      end

    end

    context "changing Scope" do

      let!(:group1_1) { Scoped.create(group: 1) }
      let!(:group1_2) { Scoped.create(group: 1) }
      let!(:group2_1) { Scoped.create(group: 2) }
      let!(:group2_2) { Scoped.create(group: 2) }
      let!(:group2_3) { Scoped.create(group: 2) }

      before do
        lambda {
          group2_2.update_attributes(group: 1)
        }.should change(group2_2, :position).from(2).to(3)
      end

      specify "@group1_1 :position is unchanged" do
        group1_1.position.should eq 1
        group1_1.reload.position.should eq 1
      end

      specify "@group1_2 :position is unchanged" do
        group1_2.position.should eq 2
        group1_2.reload.position.should eq 2
      end

      specify "@group2_1 :position is unchanged" do
        group2_1.position.should eq 1
        group2_1.reload.position.should eq 1
      end

      specify "@group2_3 :position changes to 2" do
        group2_3.position.should eq 3
        group2_3.reload.position.should eq 2
      end

    end

    context "missing Scope" do

      let!(:doc1) { Scoped.create(group: 1) }
      let!(:doc2) { Scoped.create(group: 1) }
      let!(:doc3) { Scoped.create() }

      specify "initial positions" do
        doc1.position.should eq 1
        doc2.position.should eq 2
        doc3.position.should eq 1
      end

    end

    context "removing Scope" do

      let!(:doc1) { Scoped.create(group: 1) }
      let!(:doc2) { Scoped.create(group: 1) }
      let!(:doc3) { Scoped.create() }

      it "moves to null scope" do
        lambda { doc1.update_attributes(group: nil); doc1.reload }.should change(doc1, :position).from(1).to(2)
        lambda { doc1.update_attributes(group: nil); doc2.reload }.should change(doc2, :position).from(2).to(1)
        lambda { doc1.update_attributes(group: nil); doc3.reload }.should_not change(doc3, :position)
      end

    end

  end


  describe "#destroy" do

    context "from a Collection" do

      let!(:group1_1) { Scoped.create(group: 1) }
      let!(:group1_2) { Scoped.create(group: 1) }
      let!(:group2_1) { Scoped.create(group: 2) }
      let!(:group2_2) { Scoped.create(group: 2) }
      let!(:group2_3) { Scoped.create(group: 2) }

      context "for group2_1" do

        before do
          group2_1.destroy
        end

        it "should not update group1_1's :position" do
          group1_1.position.should eq 1
          group1_1.reload.position.should eq 1
        end

        it "should not update group1_2's :position" do
          group1_2.position.should eq 2
          group1_2.reload.position.should eq 2
        end

        it "should update group2_2's :position to 1" do
          group2_2.position.should eq 2
          group2_2.reload.position.should eq 1
        end

        it "should update group2_3's :position to 2" do
          group2_3.position.should eq 3
          group2_3.reload.position.should eq 2
        end

      end

    end

    context "from an Embedded Collection" do

      let!(:container) { Container.create }
      let!(:group1_1) { container.scoped_items.create(group: 1) }
      let!(:group1_2) { container.scoped_items.create(group: 1) }
      let!(:group2_1) { container.scoped_items.create(group: 2) }
      let!(:group2_2) { container.scoped_items.create(group: 2) }
      let!(:group2_3) { container.scoped_items.create(group: 2) }

      context "for group2_2" do

        before do
          group2_2.destroy
        end

        it "should not update group1_1's :position" do
          group1_1.position.should eq 1
          group1_1.reload.position.should eq 1
        end

        it "should not update group1_2's :position" do
          group1_2.position.should eq 2
          group1_2.reload.position.should eq 2
        end

        it "should not update group2_1's :position" do
          group2_1.position.should eq 1
          group2_1.reload.position.should eq 1
        end

        it "should update group2_3's :position to 2" do
          group2_3.position.should eq 3
          container.reload.scoped_items.find(group2_3.id).position.should eq 2
        end

      end

    end

  end


  describe "#update_positions_in_list!" do

    context "on a Collection" do

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

    context "on an Embedded Collection" do

      let(:container) { Container.create! }
      let!(:doc1) { container.items.create! }
      let!(:doc2) { container.items.create! }
      let!(:doc3) { container.items.create! }
      let!(:doc4) { container.items.create! }

      before do
        container.items.update_positions_in_list!([doc2.id, doc1.id, doc4.id, doc3.id])
      end

      it "should change doc1 from :position of 1 to 2" do
        doc1.position.should eq 1
        doc1.reload.position.should eq 2
      end

      it "should change doc2 from :position of 2 to 1" do
        doc2.position.should eq 2
        doc2.reload.position.should eq 1
      end

      it "should change doc3 from :position of 3 to 4" do
        doc3.position.should eq 3
        doc3.reload.position.should eq 4
      end

      it "should change doc4 from :position of 4 to 3" do
        doc4.position.should eq 4
        doc4.reload.position.should eq 3
      end
    end

    context "on a Deeply Embedded Collection" do

      let(:root) do
        Container.create!
      end

      let(:embedded) do
        root.items.create!
      end

      let!(:doc1) { embedded.items.create! }
      let!(:doc2) { embedded.items.create! }
      let!(:doc3) { embedded.items.create! }
      let!(:doc4) { embedded.items.create! }

      before do
        embedded.items.update_positions_in_list!([doc3.id, doc4.id, doc1.id, doc2.id])
      end

      it "should change doc1 from :position of 1 to 3" do
        doc1.position.should eq 1
        doc1.reload.position.should eq 3
      end

      it "should change @doc2 from :position of 2 to 4" do
        doc2.position.should eq 2
        doc2.reload.position.should eq 4
      end

      it "should change @doc3 from :position of 3 to 1" do
        doc3.position.should eq 3
        doc3.reload.position.should eq 1
      end

      it "should change @doc4 from :position of 4 to 2" do
        doc4.position.should eq 4
        doc4.reload.position.should eq 2
      end

    end

  end

end
