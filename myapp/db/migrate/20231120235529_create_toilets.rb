class CreateToilets < ActiveRecord::Migration[7.0]
  def change
    create_table :toilets do |t|
      t.string :name
      t.st_point :location, geographic: true

      t.timestamps
    end
  end
end
