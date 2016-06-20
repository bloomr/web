require 'rails_helper'

RSpec.describe Amazon::Search, type: :model do
  before :each do
    allow(HTTParty).to receive(:get)
    ENV['AWS_PARTNER_ACCESS_KEY_ID'] = 'aws_id'
    ENV['AWS_PARTNER_SECRET_KEY'] = 'aws_secret'
  end

  describe '#search' do
    let(:result) { Amazon::Search.books(keywords, false) }

    context 'when no keyword is provided' do
      let(:keywords) { nil }

      it 'returns an empty array' do
        expect(result).to match_array([])
      end
    end

    context 'when an error code is returned' do
      let(:keywords) { 'legitimate keywords' }

      before :each do
        allow(HTTParty).to receive(:get)
          .and_return(double('response', code: 500))
      end

      it 'returns an empty array' do
        expect(result).to match_array([])
      end
    end

    context 'when a response is returned' do
      let(:keywords) { 'legitimate keywords' }

      before :each do
        allow(HTTParty).to receive(:get)
          .and_return(double('response', code: 200, body: body))
      end

      context 'with one book' do
        let(:body) { build_xml(image_url: 'image_url', author: 'author', title: 'title', isbn: '1234') }

        it 'returns a book' do
          expect(result.length).to eq(1)
          expect(result[0].author).to eq('author')
          expect(result[0].title).to eq('title')
          expect(result[0].isbn).to eq('1234')
          expect(result[0].image_url).to eq('image_url')
        end
      end

      context 'with a malformed book' do
        let(:body) { build_bad_xml }

        it 'returns an empty arry' do
          expect(result.length).to eq(0)
        end
      end
    end
  end

  private

  def build_xml options
<<-EOF
<?xml version="1.0" ?>
<ItemSearchResponse>
  <Items>
    <Item>
      <MediumImage><URL>#{options[:image_url]}</URL></MediumImage>
      <ItemAttributes>
        <Author>#{options[:author]}</Author>
        <Title>#{options[:title]}</Title>
        <ISBN>#{options[:isbn]}</ISBN>
      </ItemAttributes>
    </Item>
  </Items>
</ItemSearchResponse>
EOF
  end

  def build_bad_xml
<<-EOF
<?xml version="1.0" ?>
<ItemSearchResponse>
  <Items>
    <Item>
    </Item>
  </Items>
</ItemSearchResponse>
EOF
  end
end
