require 'csv'

class Cat
  CATS_PATH = Rails.root.join('config', 'cats.csv')
  def self.stats
    @cats = CSV.read(CATS_PATH,headers: true).group_by do |cat|
      cat["type"]
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
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
      cat["subtype"].split(' ').first
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.get_cats(order_type='weird')
    cats_path = Rails.root.join('config', 'cats.csv')
    cat_ordering = {
        "award" => 0,
        "cat" => 2,
        "greed" => 5,
        "starter" => 3,
        "positive" => 4,
        "negative" => 6,
        "action" => 1,
        "upgrade" => 10
    }
    CSV.read(cats_path,headers: true).sort_by do
    | cat |
      if order_type == 'weird'
        cat_order = cat_ordering[cat["type"]]
        if cat_order.present?
          cat_order
        else
          cat['description'].present? ? cat['description'].length : 1000
        end
      else
        cat['row_num'].to_i
      end
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

  def self.need_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'cat'
    end.group_by do |cat|
      cat["Number-tl"].chars.map do |num|
        if num == 'F' || num == 'C'
          1
        else
          2
        end
      end.reduce(:+)
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.greed_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'cat'
    end.group_by do |cat|
      cat["Number-tr"].chars.map do |num|
        if num == 'F' || num == 'C'
          1
        else
          2
        end
      end.reduce(:+)
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.ability_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'cat'
    end.group_by do |cat|
      cat["description"].present? && cat['description'].length > 5
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.action_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'action'
    end.group_by do |cat|
      cat['subtype']
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.action_cost_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'action'
    end.group_by do |cat|
      cat['Number-tl']
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.action_type_distro
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'action'
    end.group_by do |cat|
      desc = cat['description'].downcase
      Cat.classify(desc).join(",")
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.non_resource_cards
    CSV.read(CATS_PATH, headers: true).select do |cat|
      cat["type"] == 'action'
    end.select do |cat|
      desc = cat['description'].downcase
      !Cat.classify(desc).present?
    end
  end

  def self.classify(desc)
    types = []
    if desc.match?(/add \d food/) || desc.match?(/steal \d food/)
      types << "add food"
    end
    if desc.match?(/add \d catnip/) || desc.match?(/steal \d catnip/)
      types << "add catnip"
    end
    if desc.match?(/add \d toy/) || desc.match?(/steal \d toy/)
      types << "add toy"
    end
    if desc.match?(/add \d litterbox/) || desc.match?(/steal \d litterbox/)
      types << "add litterbox"
    end
    if desc.match?(/remove \d food/) || desc.match?(/loses \d food/)
      types << "remove food"
    end
    if desc.match?(/remove \d toy/) || desc.match?(/loses \d toy/)
      types << "remove toy"
    end
    if desc.match?(/remove \d litterbox/) || desc.match?(/loses \d litterbox/)
      types << "remove litterbox"
    end
    if desc.match?(/remove \d catnip/) || desc.match?(/loses \d catnip/)
      types << "remove catnip"
    end
    types
  end

  def self.subtype_distro
    CSV.read(CATS_PATH, headers: true).group_by do |cat|
      cat['type']
    end.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end

  def self.make_image(cats =get_cats.first(70), num=0)
    html = CatsController.render :just_cards, assigns: { cats: cats}
    kit = IMGKit.new(html, width: 325*10, height: 3050)
    css = StringIO.new( `curl http://localhost:3000/assets/cats.self-56d42432f42257ffb68aa6bf567a346540e2b96db2ccf467ad416ae450cd14c9.css` )
    kit.stylesheets << css
    css_2 = StringIO.new( `curl http://localhost:3000/assets/bootstrap.self-3529c8b3a4f85dfa856b4943cf9225a6dfa3af3b69e78b5b6f74461a6cfd72b0.css`)
    kit.stylesheets << css_2
    # css_3 = StringIO.new(`curl https://use.fontawesome.com/releases/v5.11.2/css/all.css`)
    # kit.stylesheets << css_3
    file = kit.to_file("tmp/cats#{num}.jpg")

  end

  def self.make_image_v2
    kit = IMGKit.new("http://localhost:3000/cats/printable?print=cat", width: 325*10, height: 310*7)
    kit.to_file("cats.jpg")
    kit = IMGKit.new("http://localhost:3000/cats/printable?print=action1", width: 325*10, height: 3050)
    kit.to_file("action1.jpg")
    kit = IMGKit.new("http://localhost:3000/cats/printable?print=action2", width: 325*10, height: 3050)
    kit.to_file("action2.jpg")
    Cat.type_distro
  end

  def self.make_images
    i = 0
    get_cats.each_slice(9) do |cats|
      make_image(cats, i)
      i+= 1
    end
  end

  def self.cat_distro_counts
    cat_distro.each do |cat, value|
      puts "#{cat} has #{value.count}"
    end;nil
  end
end