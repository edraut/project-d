class CreatePage < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :pages
  end
end
