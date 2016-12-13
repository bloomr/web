require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'published' do
    let(:published_keyword) { Keyword.create(tag: 'published') }
    before :each do
      Keyword.create(tag: 'not')
      create(:user_published_with_questions, keywords: [published_keyword])
    end

    it 'returns only the published one' do
      expect(Keyword.published).to match([published_keyword])
    end
  end
  describe 'normalize_tag' do
    let!(:keyword) { Keyword.create(tag: 'Compl iCatèd') }

    it 'normalized the tag' do
      expect(keyword.normalized_tag).to eq('compl-icated')
    end
  end
end
