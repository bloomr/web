class CreateJoinTableBundlesContracts < ActiveRecord::Migration
  def change
    create_table 'bundles_contracts' do |t|
      t.integer :bundle_id
      t.integer :contract_id
      t.index [:bundle_id, :contract_id], unique: true
    end
  end
end
