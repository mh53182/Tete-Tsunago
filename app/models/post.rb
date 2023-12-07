class Post < ApplicationRecord
  
  
  enum category: { everyday: 0, success: 1, graduation: 2 }
  
end
