class SeedStepInterviewQuestions < ActiveRecord::Migration
  def up
    Question.create(
      title: 'En quoi consiste votre métier exactement ?',
      description: "Dites-en un peu plus sur votre métier, pour quelqu'un qui n'en a jamais entendu parler, en vous exprimant comme à l'oral",
      position: 'a',
      step: 'first_interview'
    )

    Question.create(
      title: "Au fond, qu'est-ce qui fait que vous l'aimez, ce métier ?",
      description: "C'est peut-être cela l'essentiel non ?",
      position: 'b',
      step: 'first_interview'
    )
  end
end
