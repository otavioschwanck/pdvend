require 'rails_helper'

RSpec.describe WebContentService, type: :service do
  let!(:link) { FactoryGirl.create(:link, url: 'https://www.pdvend.com.br/') }
  let!(:service) { described_class.new(link) }

  describe '.content' do
    context 'when a valid URL' do
      before(:each) do
        WebMock.stub_request(:get, 'https://www.pdvend.com.br/')
               .to_return(body: '<h1 class="pdvend">PDVend For The Win <3</h1>')
      end

      it 'return content of the page cleaned' do
        expect(service.content).to eq(' PDVend For The Win &lt;3 ')
      end
    end

    context 'when a invalid URL' do
      before(:each) do
        WebMock.stub_request(:get, 'https://www.pdvend.com.br/')
               .and_return(status: 404)
      end

      it 'do error' do
        expect(service.content).to eq('')
      end
    end
  end
end
