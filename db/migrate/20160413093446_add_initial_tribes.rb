class AddInitialTribes < ActiveRecord::Migration

  def up
    create_tribe('Les écolos', 'Leur mission : rendre notre monde durable', %w( Écologie Développement\ durable ))
    create_tribe('Les créatifs', 'Dévoiler la beauté du monde qui nous entoure, voilà ce qui les fait vibrer', %w( Création Design Artisanat Culture ))
    create_tribe('Les humanistes', "Leur mission : remettre l'humain au centre de notre quotidien", %w( Partage Transmission Empathie Accompagnement ))
    create_tribe("Les orga'", "Logique et organisation sont leurs armes pour mettre un peu d'ordre dans notre monde", %w( Modélisation Anticipation Argumenter ))
    create_tribe('Les 3.0', 'Ils utilisent la technologie pour inventer le monde de demain', %w( Innovation Curiosité Numérique Informatique ))
    create_tribe('Les scientifiques', 'Résoudre les grands mystères de la vie et explorer de nouveaux horizons', %w( Technique Médecine Recherche ))

    User.all.map{ |u| u.tribes = u.default_tribes; u.save }
  end

  def down
    Keyword.all.map{ |k| k.tribe = nil; k.save }
    Tribe.all.map(&:destroy)
  end

  def create_tribe name, description, tags
    keywords = tags.map{ |t| k = Keyword.find_by tag: t; raise "no tag #{t}" if k.nil?; k}
    Tribe.create(name: name, description: description, keywords: keywords)
  end
end
