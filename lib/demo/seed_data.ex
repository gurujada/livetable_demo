defmodule Demo.SeedData do
  @moduledoc """
  Indian seed data generator for LiveTable demos.
  Provides realistic Indian names, cities, companies, and business data.
  """

  # Indian first names (male)
  @male_first_names ~w(
    Aarav Vivaan Aditya Arjun Krishna Rohan Vikram Rahul Amit Ankit
    Sanjay Rajesh Suresh Mahesh Dinesh Ganesh Ramesh Naresh Hitesh Nilesh
    Abhishek Akash Aman Aryan Chirag Deepak Gaurav Harsh Ishaan Jai
    Karan Kartik Kunal Lakshmi Manish Mohit Naveen Nikhil Omkar Pankaj
    Pranav Prateek Ravi Sachin Sahil Shivam Siddhant Tushar Varun Yash
  )

  # Indian first names (female)
  @female_first_names ~w(
    Aadhya Ananya Saanvi Priya Neha Divya Meera Pooja Shruti Sneha
    Aishwarya Anjali Bhavna Chitra Deepika Ekta Garima Harini Ishita Jaya
    Kavya Kirti Lakshmi Madhuri Nandini Payal Riya Sakshi Tanvi Uma
    Vidya Yamini Zara Aditi Bharti Chetna Disha Gauri Heena Isha
    Juhi Komal Lavanya Mitali Nisha Pallavi Ritika Shalini Tanya Urmi
  )

  # Indian last names
  @last_names ~w(
    Sharma Verma Gupta Patel Singh Reddy Nair Iyer Kumar Mehta
    Agarwal Joshi Mishra Pandey Tiwari Yadav Saxena Sinha Banerjee Chatterjee
    Mukherjee Das Roy Ghosh Sen Bose Dutta Chowdhury Bhattacharya Kar
    Pillai Menon Krishnan Rajan Subramaniam Venkatesh Rao Naidu Hegde Shetty
    Kulkarni Deshmukh Patil Jain Choudhary Thakur Chauhan Rathore Rajput Kapoor
  )

  # Indian cities with states
  @cities_with_states [
    {"Mumbai", "Maharashtra"},
    {"Delhi", "Delhi"},
    {"Bangalore", "Karnataka"},
    {"Chennai", "Tamil Nadu"},
    {"Kolkata", "West Bengal"},
    {"Hyderabad", "Telangana"},
    {"Pune", "Maharashtra"},
    {"Ahmedabad", "Gujarat"},
    {"Jaipur", "Rajasthan"},
    {"Lucknow", "Uttar Pradesh"},
    {"Surat", "Gujarat"},
    {"Kanpur", "Uttar Pradesh"},
    {"Nagpur", "Maharashtra"},
    {"Indore", "Madhya Pradesh"},
    {"Thane", "Maharashtra"},
    {"Bhopal", "Madhya Pradesh"},
    {"Visakhapatnam", "Andhra Pradesh"},
    {"Patna", "Bihar"},
    {"Vadodara", "Gujarat"},
    {"Ghaziabad", "Uttar Pradesh"},
    {"Ludhiana", "Punjab"},
    {"Agra", "Uttar Pradesh"},
    {"Nashik", "Maharashtra"},
    {"Faridabad", "Haryana"},
    {"Meerut", "Uttar Pradesh"},
    {"Rajkot", "Gujarat"},
    {"Varanasi", "Uttar Pradesh"},
    {"Srinagar", "Jammu & Kashmir"},
    {"Aurangabad", "Maharashtra"},
    {"Dhanbad", "Jharkhand"},
    {"Amritsar", "Punjab"},
    {"Allahabad", "Uttar Pradesh"},
    {"Ranchi", "Jharkhand"},
    {"Coimbatore", "Tamil Nadu"},
    {"Jabalpur", "Madhya Pradesh"},
    {"Gwalior", "Madhya Pradesh"},
    {"Vijayawada", "Andhra Pradesh"},
    {"Jodhpur", "Rajasthan"},
    {"Madurai", "Tamil Nadu"},
    {"Raipur", "Chhattisgarh"},
    {"Kochi", "Kerala"},
    {"Chandigarh", "Chandigarh"},
    {"Guwahati", "Assam"},
    {"Mysore", "Karnataka"},
    {"Thiruvananthapuram", "Kerala"},
    {"Noida", "Uttar Pradesh"},
    {"Gurugram", "Haryana"},
    {"Dehradun", "Uttarakhand"},
    {"Mangalore", "Karnataka"},
    {"Hubli", "Karnataka"}
  ]

  @states [
    "Maharashtra",
    "Karnataka",
    "Tamil Nadu",
    "Gujarat",
    "Rajasthan",
    "Uttar Pradesh",
    "West Bengal",
    "Telangana",
    "Andhra Pradesh",
    "Kerala",
    "Punjab",
    "Haryana",
    "Madhya Pradesh",
    "Bihar",
    "Jharkhand",
    "Odisha",
    "Chhattisgarh",
    "Assam",
    "Uttarakhand",
    "Himachal Pradesh",
    "Goa"
  ]

  @regions ~w(North South East West Central)

  # Indian company name components
  @company_prefixes ~w(
    Tata Reliance Bajaj Infosys Wipro HCL Mahindra Godrej Birla Adani
    Bharti Larsen Tech Digi Cyber Cloud Data Info Smart Digital
  )

  @company_cores ~w(
    Solutions Systems Technologies Services Industries Enterprises
    Innovations Dynamics Global Networks Digital Ventures Labs
  )

  @company_suffixes ["Pvt Ltd", "Ltd", "LLP", "India", "Group", "Corp", "Inc"]

  # Departments
  @departments [
    "Engineering",
    "Sales",
    "Marketing",
    "Finance",
    "HR",
    "Operations",
    "Product",
    "Legal",
    "Customer Support",
    "IT",
    "Research",
    "Quality",
    "Admin",
    "Procurement"
  ]

  # Designations by level
  @designations %{
    junior: ["Associate", "Trainee", "Executive", "Junior Engineer", "Analyst"],
    mid: ["Senior Executive", "Engineer", "Team Lead", "Specialist", "Consultant"],
    senior: ["Manager", "Senior Manager", "Principal", "AVP", "Deputy Manager"],
    leadership: ["Director", "VP", "Senior Director", "Head", "General Manager"]
  }

  # Products: {category, [{brand, [{product line, list price}]}], [variant]}. A brand only
  # sells its own lines, and every variant of a line is priced near the line's price.
  @catalogue [
    {"Phones",
     [
       {"Samsung", [{"Galaxy S24", 74_999}, {"Galaxy A35 5G", 30_999}, {"Galaxy M15", 12_999}]},
       {"Apple", [{"iPhone 15", 69_999}, {"iPhone 15 Plus", 79_999}, {"iPhone 16 Pro", 119_999}]},
       {"OnePlus", [{"12R", 39_999}, {"Nord CE 4", 24_999}, {"Nord 4", 29_999}]},
       {"Xiaomi", [{"Redmi Note 13", 17_999}, {"Redmi 13C", 8_999}, {"14 Civi", 42_999}]},
       {"Realme", [{"Narzo 70x", 11_999}, {"12 Pro+", 29_999}, {"C65", 9_999}]},
       {"Vivo", [{"V30", 33_999}, {"T3 5G", 19_999}, {"Y28", 13_999}]}
     ], ["128 GB, Black", "128 GB, Blue", "256 GB, Black", "256 GB, Silver", "512 GB, Titanium"]},
    {"Laptops",
     [
       {"HP", [{"Pavilion 15", 62_999}, {"Victus 16", 78_999}, {"EliteBook 840", 119_999}]},
       {"Dell", [{"Inspiron 14", 54_999}, {"Vostro 3520", 41_999}, {"XPS 13", 139_999}]},
       {"Lenovo", [{"IdeaPad Slim 3", 44_999}, {"ThinkPad E14", 71_999}, {"Legion 5", 124_999}]},
       {"Asus", [{"Vivobook 15", 39_999}, {"Zenbook 14", 89_999}, {"ROG Strix G16", 149_999}]},
       {"Apple", [{"MacBook Air M3", 114_999}, {"MacBook Pro 14", 169_999}]}
     ], ["8 GB, 512 GB SSD", "16 GB, 512 GB SSD", "16 GB, 1 TB SSD", "32 GB, 1 TB SSD"]},
    {"Audio",
     [
       {"boAt", [{"Airdopes 141", 1_299}, {"Rockerz 450", 1_499}, {"Stone 1200", 3_999}]},
       {"JBL", [{"Tune 760NC", 7_999}, {"Flip 6", 11_999}, {"Go 4", 3_999}]},
       {"Sony", [{"WH-1000XM5", 29_999}, {"WF-C700N", 8_999}, {"SRS-XB100", 4_499}]},
       {"Noise", [{"Buds VS104", 1_199}, {"Airwave", 2_499}]}
     ], ["Black", "Blue", "White", "Teal"]},
    {"Watches",
     [
       {"Titan", [{"Neo Analog", 3_495}, {"Raga Viva", 8_995}, {"Edge Ceramic", 24_995}]},
       {"Fastrack", [{"Reflex Play", 5_995}, {"Limitless FS1", 1_995}]},
       {"Casio",
        [{"G-Shock GA-2100", 9_995}, {"Vintage A168", 4_495}, {"Edifice EFR-526", 11_995}]},
       {"Fossil", [{"Grant Chronograph", 12_995}, {"Gen 6 Smartwatch", 21_995}]}
     ], ["Black dial", "Blue dial", "Silver", "Rose gold"]},
    {"Footwear",
     [
       {"Nike", [{"Air Max SC", 6_295}, {"Revolution 7", 3_695}, {"Court Vision Low", 4_995}]},
       {"Adidas", [{"Ultraboost Light", 15_999}, {"Runfalcon 3", 4_299}, {"Grand Court", 4_599}]},
       {"Puma", [{"Smash v2", 2_999}, {"Softride Pro", 4_999}]},
       {"Woodland", [{"Leather Boots", 5_995}, {"Trekking Shoes", 4_495}]},
       {"Bata", [{"Formal Oxfords", 2_499}, {"Comfit Sandals", 999}]}
     ], ["UK 7", "UK 8", "UK 9", "UK 10"]},
    {"Clothing",
     [
       {"Allen Solly", [{"Slim Fit Shirt", 1_799}, {"Chinos", 2_199}, {"Polo T-Shirt", 1_299}]},
       {"Peter England",
        [{"Formal Shirt", 1_599}, {"Pleated Trousers", 1_999}, {"Blazer", 5_999}]},
       {"Fabindia", [{"Cotton Kurta", 1_690}, {"Silk Saree", 7_490}, {"Nehru Jacket", 3_490}]},
       {"Biba", [{"Anarkali Kurta", 2_999}, {"Palazzo Set", 2_499}]},
       {"Levi's", [{"511 Slim Jeans", 3_299}, {"Trucker Jacket", 4_999}]}
     ], ["S", "M", "L", "XL"]},
    {"Home & Kitchen",
     [
       {"Prestige",
        [{"Pressure Cooker 5 L", 2_199}, {"Induction Cooktop", 2_999}, {"Omega Tawa", 899}]},
       {"Philips",
        [{"Air Fryer HD9252", 8_999}, {"Mixer Grinder 750 W", 4_499}, {"Steam Iron", 1_899}]},
       {"Bajaj",
        [{"Ceiling Fan 1200 mm", 2_799}, {"OTG 28 L", 6_499}, {"Water Heater 15 L", 7_999}]},
       {"Milton", [{"Thermosteel Flask 1 L", 999}, {"Lunch Box Set", 749}]}
     ], ["Black", "Silver", "Red", "Pack of 2"]},
    {"Beauty",
     [
       {"Lakmé", [{"9to5 Foundation", 649}, {"Sun Expert SPF 50", 399}, {"Eyeconic Kajal", 249}]},
       {"Nivea", [{"Soft Light Cream", 299}, {"Men Face Wash", 219}]},
       {"Mamaearth", [{"Vitamin C Serum", 599}, {"Onion Hair Oil", 449}]},
       {"Forest Essentials", [{"Facial Ubtan", 1_475}, {"Bhringraj Hair Oil", 1_250}]}
     ], ["30 ml", "50 ml", "100 ml", "200 ml"]},
    {"Furniture",
     [
       {"Wakefit",
        [{"Orthopedic Mattress", 14_999}, {"Study Table", 6_499}, {"Sofa Cum Bed", 24_999}]},
       {"Godrej Interio",
        [{"Ergonomic Office Chair", 11_999}, {"3-Door Wardrobe", 32_999}, {"Bookshelf", 7_999}]},
       {"Nilkamal", [{"Plastic Chair", 899}, {"Shoe Rack", 2_499}]},
       {"IKEA", [{"Billy Bookcase", 5_990}, {"Poäng Armchair", 12_990}]}
     ], ["Walnut", "Teak", "Grey", "White"]},
    {"Sports",
     [
       {"Yonex", [{"Astrox 88D Racket", 15_999}, {"Mavis 350 Shuttlecocks", 1_299}]},
       {"SG", [{"Kashmir Willow Bat", 2_999}, {"Test Batting Gloves", 1_599}]},
       {"Decathlon",
        [{"Yoga Mat 8 mm", 999}, {"Football Size 5", 799}, {"Trekking Backpack 30 L", 1_999}]},
       {"Cosco", [{"Basketball", 899}, {"Skipping Rope", 299}]}
     ], ["Red", "Blue", "Black", "Green"]},
    {"Grocery",
     [
       {"Tata", [{"Tea Gold 500 g", 349}, {"Sampann Toor Dal 1 kg", 219}, {"Salt 1 kg", 28}]},
       {"Aashirvaad", [{"Atta 5 kg", 289}, {"Multigrain Atta 5 kg", 359}]},
       {"Amul", [{"Butter 500 g", 285}, {"Pure Ghee 1 L", 649}]},
       {"Haldiram's", [{"Aloo Bhujia 1 kg", 299}, {"Soan Papdi 500 g", 199}]}
     ], ["Single", "Pack of 2", "Pack of 3"]}
  ]

  @brand_countries %{
    "Samsung" => "South Korea",
    "Apple" => "USA",
    "OnePlus" => "China",
    "Xiaomi" => "China",
    "Realme" => "China",
    "Vivo" => "China",
    "HP" => "USA",
    "Dell" => "USA",
    "Lenovo" => "China",
    "Asus" => "Taiwan",
    "JBL" => "USA",
    "Sony" => "Japan",
    "Casio" => "Japan",
    "Fossil" => "USA",
    "Nike" => "USA",
    "Adidas" => "Germany",
    "Puma" => "Germany",
    "Levi's" => "USA",
    "Philips" => "Netherlands",
    "Nivea" => "Germany",
    "IKEA" => "Sweden",
    "Yonex" => "Japan",
    "Decathlon" => "France"
  }

  # Order/Invoice statuses
  @order_statuses ~w(pending confirmed shipped delivered cancelled)
  @payment_statuses ~w(pending paid refunded partially_paid)
  @invoice_statuses ~w(draft sent paid overdue cancelled)

  # Lead sources and stages
  @lead_sources [
    "Website",
    "Referral",
    "LinkedIn",
    "Facebook",
    "Instagram",
    "Trade Show",
    "Cold Call",
    "Email Campaign",
    "Google Ads",
    "Partner"
  ]
  @lead_stages ~w(New Contacted Qualified Proposal Negotiation Won Lost)

  # Project types and statuses
  @project_types [
    "Web App",
    "Mobile App",
    "API Development",
    "Consulting",
    "Data Analytics",
    "Cloud Migration",
    "DevOps",
    "E-commerce",
    "CRM",
    "ERP"
  ]
  @project_statuses ~w(planning active on_hold completed cancelled)

  # Payment terms
  @payment_terms [
    {"Immediate", 0},
    {"Net 7", 7},
    {"Net 15", 15},
    {"Net 30", 30},
    {"Net 45", 45},
    {"Net 60", 60},
    {"Net 90", 90}
  ]

  # Public API

  def random_first_name do
    Enum.random(@male_first_names ++ @female_first_names)
  end

  def random_male_first_name, do: Enum.random(@male_first_names)
  def random_female_first_name, do: Enum.random(@female_first_names)
  def random_last_name, do: Enum.random(@last_names)

  def random_full_name do
    "#{random_first_name()} #{random_last_name()}"
  end

  def random_email(name) do
    name
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, ".")
    |> Kernel.<>("@")
    |> Kernel.<>(Enum.random(~w(gmail.com yahoo.co.in outlook.com hotmail.com rediffmail.com)))
  end

  def random_phone do
    prefix =
      Enum.random(
        ~w(98 97 96 95 94 93 92 91 90 89 88 87 86 85 84 83 82 81 80 79 78 77 76 75 74 73 72 71 70)
      )

    "#{prefix}#{:rand.uniform(99_999_999) |> Integer.to_string() |> String.pad_leading(8, "0")}"
  end

  def random_city_state do
    Enum.random(@cities_with_states)
  end

  def random_city do
    {city, _state} = random_city_state()
    city
  end

  def random_state, do: Enum.random(@states)
  def random_region, do: Enum.random(@regions)

  def random_company_name do
    prefix = Enum.random(@company_prefixes)
    core = Enum.random(@company_cores)
    suffix = Enum.random(@company_suffixes)
    "#{prefix} #{core} #{suffix}"
  end

  def random_department, do: Enum.random(@departments)

  def random_designation(level \\ nil) do
    level = level || Enum.random([:junior, :mid, :senior, :leadership])
    Enum.random(@designations[level])
  end

  def random_salary(level \\ nil) do
    case level || Enum.random([:junior, :mid, :senior, :leadership]) do
      :junior -> Enum.random(300_000..600_000)
      :mid -> Enum.random(600_000..1_200_000)
      :senior -> Enum.random(1_200_000..2_500_000)
      :leadership -> Enum.random(2_500_000..5_000_000)
    end
  end

  def random_experience(level \\ nil) do
    case level || Enum.random([:junior, :mid, :senior, :leadership]) do
      :junior -> Enum.random(0..3)
      :mid -> Enum.random(3..7)
      :senior -> Enum.random(7..15)
      :leadership -> Enum.random(12..30)
    end
  end

  def random_order_status, do: Enum.random(@order_statuses)
  def random_payment_status, do: Enum.random(@payment_statuses)
  def random_invoice_status, do: Enum.random(@invoice_statuses)
  def random_lead_source, do: Enum.random(@lead_sources)
  def random_lead_stage, do: Enum.random(@lead_stages)
  def random_project_type, do: Enum.random(@project_types)
  def random_project_status, do: Enum.random(@project_statuses)

  def product_categories, do: Enum.map(@catalogue, &elem(&1, 0))
  def random_product_category, do: Enum.random(product_categories())

  def brands do
    for({_, lines, _} <- @catalogue, {brand, _} <- lines, uniq: true, do: brand)
    |> Enum.map(&{&1, Map.get(@brand_countries, &1, "India")})
  end

  def all_departments, do: @departments
  def all_lead_sources, do: @lead_sources
  def all_lead_stages, do: @lead_stages
  def all_project_types, do: @project_types
  def all_payment_terms, do: @payment_terms
  def all_regions, do: @regions
  def all_states, do: @states
  def all_cities_with_states, do: @cities_with_states

  def random_price(min \\ 100, max \\ 100_000) do
    Enum.random(min..max) |> Decimal.new()
  end

  def random_rating do
    (:rand.uniform() * 4 + 1) |> Float.round(1) |> Decimal.from_float()
  end

  def random_date_in_past(days \\ 365) do
    Date.utc_today() |> Date.add(-Enum.random(1..days))
  end

  def random_datetime_in_past(days \\ 365) do
    DateTime.utc_now()
    |> DateTime.add(-Enum.random(1..days) * 24 * 60 * 60, :second)
    |> DateTime.truncate(:second)
  end

  def random_future_date(days \\ 90) do
    Date.utc_today() |> Date.add(Enum.random(1..days))
  end

  def random_bool(true_probability \\ 0.5) do
    :rand.uniform() < true_probability
  end

  def random_sku(prefix \\ "SKU") do
    "#{prefix}-#{:rand.uniform(999_999) |> Integer.to_string() |> String.pad_leading(6, "0")}"
  end

  def random_order_number do
    "ORD-#{Date.utc_today().year}-#{:rand.uniform(999_999) |> Integer.to_string() |> String.pad_leading(6, "0")}"
  end

  def random_invoice_number do
    "INV-#{Date.utc_today().year}-#{:rand.uniform(999_999) |> Integer.to_string() |> String.pad_leading(6, "0")}"
  end

  def random_employee_id do
    "EMP#{:rand.uniform(99999) |> Integer.to_string() |> String.pad_leading(5, "0")}"
  end

  @doc """
  A product that hangs together: its brand makes it, its price sits near its line's price,
  and its rating near its line's rating.
  """
  def random_product do
    {category, lines, variants} = Enum.random(@catalogue)
    {brand, names} = Enum.random(lines)
    {line, list_price} = Enum.random(names)
    index = Enum.random(0..(length(variants) - 1))

    # Later variants (more storage, bigger packs) cost a little more; sellers vary a little.
    price = list_price * (1 + index * 0.08) * (0.94 + :rand.uniform() * 0.08)
    line_rating = 3.6 + :erlang.phash2(line, 11) / 10
    rating = min(5.0, max(1.0, line_rating + :rand.normal() * 0.25))

    %{
      category: category,
      brand: brand,
      name: "#{brand} #{line} (#{Enum.at(variants, index)})",
      price: price |> retail_price() |> Decimal.new(),
      cost: (price / (1.15 + :rand.uniform() * 0.45)) |> Float.round(2) |> Decimal.from_float(),
      rating: rating |> Float.round(1) |> Decimal.from_float()
    }
  end

  # 24,999 rather than 25,000; 149 rather than 150.
  defp retail_price(price) when price >= 1000, do: round(price / 100) * 100 - 1
  defp retail_price(price), do: round(price / 10) * 10 - 1

  def generate_task_title do
    verbs = ~w(Review Complete Update Fix Implement Design Test Deploy Document Analyze Optimize)
    objects = ~w(Report Dashboard API Feature Module Documentation Database UI Code Integration)
    "#{Enum.random(verbs)} #{Enum.random(objects)}"
  end

  def generate_project_name do
    adjectives = ~w(Phoenix Nimbus Aurora Zenith Quantum Horizon Nova Eclipse Stellar Apex)
    nouns = ~w(Platform Portal Gateway Engine Hub System Suite Framework Solution App)
    "#{Enum.random(adjectives)} #{Enum.random(nouns)}"
  end
end
