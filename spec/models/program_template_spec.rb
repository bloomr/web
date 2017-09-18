require 'rails_helper'

RSpec.describe ProgramTemplate, type: :model do
  describe '#to_program' do
    let(:pt) { ProgramTemplate.create(name: 'pt_name', discourse: true, intercom: true) }
    let(:program) { pt.to_program }

    it { expect(program.name).to eq('pt_name') }
    it { expect(program.discourse).to be true }
    it { expect(program.intercom).to be true }
  end
end
