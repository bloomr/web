require 'rails_helper'

RSpec.describe Question, type: :model do

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

  describe 'first_interview_canonical' do
    let!(:user) { create(:user) }
    let!(:question_inter_user) { create(:question, step: 'first_interview', user: user) }
    let!(:question_inter_canon2) { create(:question, step: 'first_interview', position: 'b') }
    let!(:question_inter_canon) { create(:question, step: 'first_interview', position: 'a') }
    let!(:question) { create(:question) }

    it 'selects questions without user, with first_interview step and order by position' do
      expect(Question.first_interview_canonicals).to match([question_inter_canon, question_inter_canon2])
    end
  end

  describe '.interview?' do
    subject { question.interview? }

    context 'when the question is not in NOT_INTERVIEW_QUESTIONS' do
      let(:question) { create(:question, identifier: 'toto') }
      it { is_expected.to be(true) }
    end
    context 'when the question is NOT_INTERVIEW_QUESTIONS' do
      let(:question) { create(:question, identifier: 'love_job') }
      it { is_expected.to be(false) }
    end
  end
end
