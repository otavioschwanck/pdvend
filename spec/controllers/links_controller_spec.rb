require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe '.create' do
    context 'with valid url' do
      let!(:valid_url) { FFaker::Internet.http_url }

      before(:each) do
        WebMock.stub_request(:get, valid_url)
      end

      it 'redirect to @link show path' do
        post :create, url: valid_url

        expect(response).to redirect_to(link_path(Link.last))
      end

      it 'create a new link' do
        expect do
          post :create, url: valid_url
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

  describe '.show' do
    context 'with a valid id' do
      let!(:link) { create(:link) }

      before(:each) do
        expect_any_instance_of(WebContentService).to receive(:content).and_return('PDVend <3')
      end

      it 'return content' do
        post :show, id: link

        expect(response.body).to eq('PDVend <3')
      end

      it 'assigns link to @link' do
        post :show, id: link

        expect(assigns(:link)).to eq(link)
      end
    end

    context 'with a invalid link' do
      it 'return error' do
        expect do
          post :show, id: 331313
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
