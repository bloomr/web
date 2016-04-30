require 'rails_helper'

RSpec.describe Question, :type => :model do

  context 'when a question is saved' do
    let!(:question) { create(:question, answer: answer) }

    describe 'with a js injection' do
      let(:answer) { '<script>alert("yop");</script>' }
      it 'removes the injection' do
        expect(Question.first.answer).to eq('alert("yop");')
      end
    end

    describe 'with some legal tags' do
      let(:answer) { '<b>b</b><i>i</i><br/><ul><li>l</li></ul>' }
      it 'keep the tags' do
        expect(Question.first.answer).to eq('<b>b</b><i>i</i><br><ul><li>l</li></ul>')
      end
    end
  end

  describe '.published' do
    subject { Question.published }

    context 'when there are one published and one not published question' do
      let!(:published_question) { create(:question, published: true) }
      let!(:unpublished_question) { create(:question, published: false) }

      it { is_expected.to match_array(published_question) }
    end
  end
end
