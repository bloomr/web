class SetFirstInterviewQuestions < ActiveRecord::Migration
  def change
    not_first_interview = Question::NOT_INTERVIEW_QUESTIONS - ['love_job']
    Question.where('user_id IS NOT NULL')
            .where('identifier NOT IN (?)', not_first_interview)
            .update_all(step: 'first_interview')

    challenge_interview = Challenge.find_by(name: 'interview')

    User.includes(:challenges)
        .where(published: true).reject { |u| u.challenges.include?(challenge_interview) }
        .each { |u| u.challenges << challenge_interview; u.save }
  end
end
