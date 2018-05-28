namespace :'2018_05_28_move_program_templates_to_bundle' do
  task set: :environment do
    ProgramTemplate.all.each do |pt|
      Bundle.create(name: pt.name, program_templates: [pt])
    end

    CampaignsProgramTemplate.all.each do |cpt|
      BundlesCampaign.create(
        campaign: cpt.campaign,
        bundle: Bundle.find_by(name: cpt.program_template.name),
        price: cpt.price
      )
    end
  end
end
