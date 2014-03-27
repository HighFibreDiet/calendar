class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :description, :string
      t.column :location, :string
      t.column :start_datetime, :datetime
      t.column :end_datetime, :datetime
      t.timestamps
    end
  end
end
