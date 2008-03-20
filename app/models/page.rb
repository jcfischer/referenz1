class Page < ActiveRecord::Base
  
  belongs_to :category
  
  attr_accessible :title, :body, :category
  attr_readonly :created_at
  
  validates_presence_of :title, :body, :category
  validates_uniqueness_of :title
  
  before_create :init_read_counter
  
  def title
    orig_title = self.read_attribute :title
    "#{orig_title} (#{self.read_counter})"
  end
  
  protected
  
  def init_read_counter
    self.read_counter = 0
  end
  
end
