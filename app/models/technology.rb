class Technology < ActiveRecord::Base
  has_and_belongs_to_many :locations


  def regex 
    return /#{self.search_regex}/
  end

end
