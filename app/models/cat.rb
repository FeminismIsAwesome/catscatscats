require 'csv'

class Cat
  CATS_PATH = Rails.root.join('config', 'cats.csv')
  def self.stats
    @cats = CSV.read(CATS_PATH,headers: true).group_by do |cat|
      cat["type"]
    end
  end

  def self.cat_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'cat'
    end.group_by do |cat|
      cat["Number-tr"]
    end
  end

  def self.bonus_distro(type)
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == type
    end.group_by do |cat|
      cat["Number-tr"]
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.cat_distro_counts
    cat_distro.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end
end