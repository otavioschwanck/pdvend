require 'rails_helper'

RSpec.describe SearchContentService, type: :service do
  describe '.search' do
    before(:each) do
      create(:link, url: 'https://www.pdvend.com.br/')
      create(:link, url: 'https://youtube.com.br/')
      create(:link, url: 'https://google.com.br/')
      create(:link, url: 'https://www.ubuntu.com/')

      WebMock.stub_request(:get, 'https://www.pdvend.com.br/')
             .to_return(body: 'PDVEND Pdvend pdvenD <3')

      WebMock.stub_request(:get, 'https://youtube.com.br/')
             .to_return(body: 'NOVO PROGRAMADOR DA PDVEND: Otavio <3')

      WebMock.stub_request(:get, 'https://google.com.br/')
             .to_return(body: 'Pesquise aqui o que você deseja')

      WebMock.stub_request(:get, 'https://www.ubuntu.com/')
             .to_return(body: 'Bem vindo ao search PDvend PDVeND')
    end

    it 'return all sites that contains pdvend' do
      service = SearchContentService.new('PDVend')

      expect(service.search).to eq(['https://www.pdvend.com.br/', 'https://www.ubuntu.com/',
                                    'https://youtube.com.br/'].to_json)
    end
  end
end
