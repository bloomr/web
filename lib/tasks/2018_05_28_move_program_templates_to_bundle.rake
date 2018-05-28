namespace :'2018_05_28_move_program_templates_to_bundle' do
  task set: :environment do
    ProgramTemplate.all.each do |pt|
      Bundle.create(name: pt.name, program_templates: [pt])
    end
  end
end
