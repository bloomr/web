class SeedNewInterviewQuestions < ActiveRecord::Migration
  def change
    Question.where(step: 'first_interview', user: nil).destroy_all

    Question.create(
      title: "Imaginez que vous rencontrez quelqu'un qui n'a jamais entendu" \
        " parler de votre métier lors d'un dîner. Comment lui décririez-vous ?",
      position: 'a',
      step: 'first_interview'
    )

    Question.create(
      title: "Au fond, qu'est-ce qui fait que vous l'aimez, ce métier ?",
      description: "C'est peut-être cela l'essentiel non ?",
      position: 'b',
      step: 'first_interview',
      identifier: 'love_job'
    )

    [
      'Votre plus beau souvenir au travail ?',
      "Votre trait de personnalité le plus fort ?",
      'La valeur la plus importante pour vous ?',
      "C'est quoi \"réussir\" dans votre métier ?",
      "Comment voyez-vous votre métier dans 10 ans ?",
      "Quand vous étiez au collège ou au lycée, " \
        "qu'est-ce que vous vouliez faire plus tard ?",
      "Combien de métiers avez vous exercé avant celui-ci, et lesquels ?",
      "Quel conseil donneriez-vous à un jeune de 15 ans " \
        "qui veut faire votre métier ?"
    ].zip('c'..'z')
      .map do |title, position|
      Question.create(
        title: title,
        position: position,
        step: 'first_interview'
      )
    end
  end
end
