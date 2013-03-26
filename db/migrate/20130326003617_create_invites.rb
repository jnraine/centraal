class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :phone
      t.string :token
      t.string :recipient
      t.timestamps
    end
  end
end
