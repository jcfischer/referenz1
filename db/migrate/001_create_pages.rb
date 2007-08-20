class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title, :size => 80
      t.text :body
      t.string :category, :size => 80

      t.timestamps 
    end
  end

  def self.down
    drop_table :pages
  end
end
