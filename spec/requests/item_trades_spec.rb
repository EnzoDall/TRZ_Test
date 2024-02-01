# spec/requests/item_trades_spec.rb

require 'rails_helper'

RSpec.describe "Item Trades", type: :request do
  let(:survivor_one) { create(:survivor, :with_items, item_quantity: 5, item_type: 'Water') }
  let(:survivor_two) { create(:survivor, :with_items, item_quantity: 5, item_type: 'Food') }
  let(:infected_survivor) { create(:survivor, :with_items, is_infected: true, item_quantity: 5, item_type: 'Water') }

  describe "POST /trades" do
    context "when both survivors are not infected" do
      it "allows the trade and updates inventory accordingly" do
        post trades_path, params: {
          trade: {
            survivor_one_id: survivor_one.id,
            survivor_one_trade: { 'Water' => 3 },
            survivor_two_id: survivor_two.id,
            survivor_two_trade: { 'Food' => 3 }
          }
        }

        expect(response).to have_http_status(:success)
        expect(survivor_one.reload.items.find_by(name: 'Food').quantity).to eq(3)
        expect(survivor_two.reload.items.find_by(name: 'Water').quantity).to eq(3)
      end
    end

    context "when one of the survivors is infected" do
      it "prevents the trade and does not update inventory" do
        post trades_path, params: {
          trade: {
            survivor_one_id: infected_survivor.id,
            survivor_one_trade: { 'Water' => 3 },
            survivor_two_id: survivor_two.id,
            survivor_two_trade: { 'Food' => 3 }
          }
        }

        expect(response).to have_http_status(:forbidden)
        expect(infected_survivor.reload.items.find_by(name: 'Food')).to be_nil
        expect(survivor_two.reload.items.find_by(name: 'Water').quantity).to eq(5)
      end
    end
    context "when item quantities do not match" do
        it "rejects the trade due to mismatched item values" do
          post trades_path, params: {
            trade: {
              survivor_one_id: survivor_one.id,
              survivor_one_trade: { 'Water' => 1 }, # Valor não corresponde
              survivor_two_id: survivor_two.id,
              survivor_two_trade: { 'Food' => 3 }
            }
          }
    
          expect(response).to have_http_status(:unprocessable_entity)
          # Verifique que os inventários não foram alterados
          expect(survivor_one.reload.items.find_by(name: 'Water').quantity).to eq(5)
          expect(survivor_two.reload.items.find_by(name: 'Food').quantity).to eq(5)
        end
      end
    
      context "when a survivor does not have enough items to trade" do
        it "prevents the trade due to insufficient items" do
          post trades_path, params: {
            trade: {
              survivor_one_id: survivor_one.id,
              survivor_one_trade: { 'Water' => 6 }, # Quantidade maior do que possui
              survivor_two_id: survivor_two.id,
              survivor_two_trade: { 'Food' => 3 }
            }
          }
    
          expect(response).to have_http_status(:unprocessable_entity)
          # Verifique que os inventários permanecem inalterados
          expect(survivor_one.reload.items.find_by(name: 'Water').quantity).to eq(5)
          expect(survivor_two.reload.items.find_by(name: 'Food').quantity).to eq(5)
        end
      end
    
      context "when attempting to trade an item that a survivor does not have" do
        it "rejects the trade due to the item not being in the survivor's inventory" do
          post trades_path, params: {
            trade: {
              survivor_one_id: survivor_one.id,
              survivor_one_trade: { 'Ammo' => 1 }, # Item não existente no inventário
              survivor_two_id: survivor_two.id,
              survivor_two_trade: { 'Food' => 1 }
            }
          }
    
          expect(response).to have_http_status(:unprocessable_entity)
          # Garanta que nenhuma alteração ocorreu nos inventários
          expect(survivor_one.reload.items.find_by(name: 'Ammo')).to be_nil
          expect(survivor_two.reload.items.find_by(name: 'Food').quantity).to eq(5)
        end
      end
  end
end
