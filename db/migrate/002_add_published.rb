class AddPublished < ActiveRecord::Migration
  def self.up
    add_column :pages, :published, :boolean
    add_column :pages, :read_counter, :integer
  end

  def self.down
    remove_column :pages, :published
    remove_column :pages, :read_counter
  end
end
