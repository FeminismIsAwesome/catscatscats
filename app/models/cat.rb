require 'csv'

class Cat
  def stats(cats_path = Rails.root.join('config', 'cats.csv'))
    @cats = CSV.read(cats_path,headers: true).group_by do |cat|
      cat["type"]
    end
  end
end