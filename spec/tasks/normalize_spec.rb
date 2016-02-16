load File.expand_path("../../../lib/tasks/normalize.rake", __FILE__)

require 'rails_helper'

RSpec.describe 'normalize task' do
  context 'when there is one keyword' do
    let(:minus) { Keyword.create(tag: 'minus') }
    let(:accent) { Keyword.create(tag: 'ém') }

    context 'when there is one user' do
      let!(:user) { create(:user, keywords: [minus, accent]) }

      context 'with one keyword in minuscule' do
        before  do
          Normalize.keywords
          user.reload
        end

        it 'change the keywords to majuscule' do
          expect(user.keywords.first.tag).to eq('Minus')
          expect(user.keywords[1].tag).to eq('Ém')
        end

        it 'erases the old one' do
          expect(Keyword.find_by(tag: 'minus')).to eq(nil)
        end

      end

      context 'with a keyword in minuscule and in majuscule' do
        let!(:majuscule) { Keyword.create(tag: 'Minus') }

        before  do
          Normalize.keywords
          user.reload
        end

        it 'links the majuscule keyword' do
          expect(user.keywords).to include(majuscule)
        end

        it 'delete the minuscule keyword' do
          expect(Keyword.find_by(tag: 'minus')).to eq(nil)
        end
      end
    end
  end
end
