class RemoveDrankFromPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :drank
  end

  def self.down
    add_column :people, :drank, :integer
  end
end
