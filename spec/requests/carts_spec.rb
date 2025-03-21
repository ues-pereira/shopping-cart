require 'rails_helper'

RSpec.describe "Carts", type: :request do
  pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"

  describe "GET /index" do
    context 'when session id is present' do
      it 'render a successful response with list' do
        cart = create(:cart)
        product = create(:product, name: 'Product A')
        create(:cart_item, cart: cart, product: product)
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        get cart_url

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to be_successful
        expect(parsed_response).to include(:id, :products, :total_price)
        expect(parsed_response[:products].first).to include(:id, :name, :quantity, :unit_price, :total_price)
      end
    end

    context 'when session id is missing' do
      it 'render a successful response with empty array' do
        get cart_url

        expect(response).to be_successful
        expect(JSON.parse(response.body)).to be_empty
      end
    end
  end

  describe "POST /add_items" do
    let(:cart) { create(:cart) }
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    context 'when the product already is in the cart' do
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      subject do
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(cart_item.reload.quantity).to eq 3
      end
    end

    context 'when the product is not yet in the cart' do
      subject do
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(cart.cart_items.count).to eq 1
        expect(cart.cart_items.first.quantity).to eq 2
      end
    end

    context 'when params is invalid' do
      subject do
        post add_item_to_cart_cart_url, params: { product_id: product.id, quantity: -1 }, as: :json
      end

      it 'returns empty array' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(response.body).to eq 'parametros invalidos'
      end

      it 'unprocessable entity' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(response).to have_http_status(422)
      end
    end
  end

  describe "POST /cart" do
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    context 'when cart does not exist' do
      subject do
        post cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'creates a new cart and adds the item to the cart' do
        expect { subject }.to change(Cart, :count).by(1)
                                                  .and change(CartItem, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it 'creates a new card em save the card_id in the session' do
        expect { subject }.to change(Cart, :count).by(1)
        expect(response.cookies['_store_session']).to be_present
      end

      it 'returns the list of items in the newly created cart' do
        subject

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(parsed_response).to include(:id, :products, :total_price)
        expect(parsed_response[:products].first).to include(:id, :name, :quantity, :unit_price, :total_price)
      end
    end

    context 'when cart already exists' do
      let(:cart) { create(:cart) }

      before do
        cookies[:cart_id] = cart.id
      end

      subject do
        post cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'adds the item to the existing cart' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        expect { subject }.to change { cart.cart_items.count }.from(0).to(1)
      end

      it 'returns the updated list of products' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(parsed_response).to include(:id, :products, :total_price)
        expect(parsed_response[:products].first).to include(:id, :name, :quantity, :unit_price, :total_price)
      end
    end

    context 'when params is invalid' do
      let(:cart) { create(:cart) }

      subject do
        post cart_url, params: { product_id: product.id, quantity: -1 }, as: :json
      end

      it 'returns empty array' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(response.body).to eq 'parametros invalidos'
      end

      it 'unprocessable entity' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(response).to have_http_status(422)
      end
    end

    context 'when product already registered' do
      let(:cart) { create(:cart) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      subject do
        post cart_url, params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'returns unprocessable entity' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(response).to have_http_status(422)
      end

      it 'returns response empty array' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(response.body).to eq 'item já foi registrado'
      end
    end
  end

  describe 'DELETE /cart/:product_id' do
    let(:product) { create(:product, name: 'Test Product', price: 10.0) }

    context 'when product exists in the cart' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product, name: 'Test Product X', price: 10.0) }
      let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

      subject do
        delete remove_item_cart_url(product_id: product.id)
      end

      it 'remove item with sucess' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        expect { subject }.to change { cart.cart_items.count }.from(1).to(0)
      end

      it 'returns empty array' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to be_empty
        expect(response).to have_http_status(200)
      end
    end

    context 'when product does not exist in the cart' do
      let(:cart) { create(:cart) }
      let(:product) { create(:product, name: 'Test Product X', price: 10.0) }

      subject do
        delete remove_item_cart_url(product_id: product.id)
      end

      it 'returns message error' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        expect(response).to have_http_status(422)
        expect(response.body).to eq 'Produto nao encontrado no carrinho'
      end
    end

    context 'when cart does not exist' do
      let(:product) { create(:product, name: 'Test Product X', price: 10.0) }

      subject do
        delete remove_item_cart_url(product_id: product.id)
      end

      it 'returns message error' do
        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: nil })

        subject

        expect(response).to have_http_status(422)
        expect(response.body).to eq 'Carrinho não foi localizado'
      end
    end

    context 'when cart has multiple item and one is removed' do
      let(:cart) { create(:cart) }
      let(:product_a) { create(:product, name: 'Test Product A', price: 10.0) }
      let(:product_b) { create(:product, name: 'Test Product B', price: 10.0) }

      subject do
        delete remove_item_cart_url(product_id: product_a.id)
      end

      it 'remove item with sucess' do
        create(:cart_item, cart: cart, product: product_a, quantity: 1)
        create(:cart_item, cart: cart, product: product_b, quantity: 1)

        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        expect { subject }.to change { cart.cart_items.count }.from(2).to(1)
        expect(response).to have_http_status(:ok)
      end

      it 'returns updated list' do
        create(:cart_item, cart: cart, product: product_a, quantity: 1)
        create(:cart_item, cart: cart, product: product_b, quantity: 1)

        allow_any_instance_of(CartsController).to receive(:session).and_return({ cart_id: cart.id })

        subject

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(response).to be_successful
        expect(parsed_response).to include(:id, :products, :total_price)
        expect(parsed_response[:products].first).to include(:id, :name, :quantity, :unit_price, :total_price)
      end
    end
  end
end
