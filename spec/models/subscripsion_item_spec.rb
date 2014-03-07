require 'spec_helper'

describe Item::Subscripsion do
  context "relation to fee" do
    let(:item)   { create(:subscripsion_item) }
    let!(:other) { create(:entri_item) }

    it "copied attributes" do
      expect(item.description).to eq item.fee.description(:full)
      expect(item.start_date).to eq item.fee.start_date
      expect(item.end_date).to eq item.fee.end_date
      expect(item.cost).to eq item.fee.amount
    end

    it "reverse association" do
      expect(item.fee.items.size).to eq 1
      expect(item.fee.items.first).to eq item
      # expect(item.fee.items.first.object_id).to eq item.object_id
    end
  end

  context "legacy subscription" do
    let(:item) { create(:legacy_subscripsion_item) }

    it "should have no fee" do
      expect(item.fee).to be_nil
      expect(item.source).to eq "www1"
    end

    it "normally a fee is required" do
      expect{create(:nofee_subscripsion_item)}.to raise_error
    end
  end
end
