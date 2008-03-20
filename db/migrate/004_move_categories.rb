class MoveCategories < ActiveRecord::Migration
  def self.up
    rename_column :pages, :category, :kategory
    Page.find(:all).each do |page|
      cat = Category.find_or_create_by_name(page.kategory)
      page.category = cat
      page.save
    end

    remove_column :pages, :kategory
  end

  def self.down
    add_colum :pages, :kategory, :string

    Page.find(:all).each do |page|
      cat = page.category
      page.kategory = cat.name
    end

    rename_column :pages, :kategory, :category
  end

end
