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

  def self.cat_power_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'cat'
    end.group_by do |cat|
      (cat["description"] || "").length > 0
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.cat_power_distro_detailed
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'cat'
    end.group_by do |cat|
      "#{cat["description"].present?}--#{cat['subtype']}"
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.type_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'cat'
    end.group_by do |cat|
      cat["subtype"]
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
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