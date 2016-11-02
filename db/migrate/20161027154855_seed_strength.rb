class SeedStrength < ActiveRecord::Migration
  def up
    names = ['Gentillesse et générosité',
             'Créativité, ingéniosité, et originalité',
             'Le pardon',
             'Curiosité et intérêt accordé au monde',
             'Reconnaissance de la beauté',
             'Joie de vivre, enthousiasme, vigueur et énergie',
             'Gratitude',
             'Humour et enjouement',
             "Citoyenneté, travail d’équipe et fidélité",
             'Impartialité, équité, et justice',
             'Espoir, optimisme, et anticipation du futur',
             'Leadership (capacité à diriger)',
             "Amour de l’étude, de l’apprentissage",
             'Modestie et humilité',
             'Intelligence sociale',
             "Capacité d’aimer et d’être aimé(e)",
             "Discernement, pensée critique, et ouverture d’esprit",
             'Honnêteté, intégrité, et sincérité',
             'Perspective',
             'Assiduité, application, et persévérance',
             'Spiritualité, religiosité, but dans la vie',
             'Maîtrise de soi et autorégulation',
             'Précaution, prudence, et discrétion',
             'Courage et vaillance']

    names.each { |e| Strength.create(name: e) }
  end
end
