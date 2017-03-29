require 'rails_helper'

RSpec.describe Link, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:url) }
  end

  context 'database columns' do
    it { is_expected.to have_db_column(:url).of_type(:string) }
  end
end
