class CreateTestimonies < ActiveRecord::Migration
  def change
    create_table :testimonies do |t|
      t.string :title
      t.string :body
      t.string :person
      t.string :date
      t.string :position, default: ''

      t.timestamps null: false
    end
  end
end
