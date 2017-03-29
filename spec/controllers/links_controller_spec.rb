require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe '.create' do
    context 'with valid url' do
      let!(:valid_url) { FFaker::Internet.http_url }

      before(:each) do
        WebMock.stub_request(:get, valid_url)
      end

      it 'redirect to @link show path' do
        post :create, params: { url: valid_url }

        expect(response).to redirect_to(link_path(Link.last))
      end

      it 'create a new link' do
        expect do
          post :create, params: { url: valid_url }
        end.to change(Link, :count).by(1)
      end
    end

    context 'with invalid url' do
      it 'with no url param' do
        post :create

        expect(response.status).to eq 402
      end
    end
  end

  describe '.index' do
    it 'use SearchContenctService' do
      json = ['google.com'].to_json
      expect_any_instance_of(SearchContentService).to receive(:search).and_return(json)

      get :index, params: { key_word: 'Pesquisar' }

      expect(response.body).to eq(json)
    end
  end

  describe '.show' do
    context 'with a valid id' do
      let!(:link) { create(:link) }

      before(:each) do
        expect_any_instance_of(WebContentService).to receive(:content).and_return('PDVend <3')
      end

      it 'return content' do
        post :show, params: { id: link }

        expect(response.body).to eq('PDVend <3')
      end

      it 'assigns link to @link' do
        post :show, params: { id: link }

        expect(assigns(:link)).to eq(link)
      end
    end

    context 'with a invalid link' do
      it 'return error' do
        expect do
          post :show, params: { id: 331_313 }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
