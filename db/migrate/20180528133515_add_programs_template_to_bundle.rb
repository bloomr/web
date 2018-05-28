class AddProgramsTemplateToBundle < ActiveRecord::Migration
  def change
    add_reference :program_templates, :bundle
    add_foreign_key :program_templates, :bundles
  end
end
