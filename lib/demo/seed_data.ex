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

  @states ~w(
    Maharashtra Karnataka Tamil\ Nadu Gujarat Rajasthan Uttar\ Pradesh
    West\ Bengal Telangana Andhra\ Pradesh Kerala Punjab Haryana
    Madhya\ Pradesh Bihar Jharkhand Odisha Chhattisgarh Assam
    Uttarakhand Himachal\ Pradesh Goa
  )

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

  @company_suffixes ~w(
    Pvt\ Ltd Ltd LLP India Group Corp Inc
  )

  # Departments
  @departments ~w(
    Engineering Sales Marketing Finance HR Operations Product Legal
    Customer\ Support IT Research Quality Admin Procurement
  )

  # Designations by level
  @designations %{
    junior: ~w(Associate Trainee Executive Junior\ Engineer Analyst),
    mid: ~w(Senior\ Executive Engineer Team\ Lead Specialist Consultant),
    senior: ~w(Manager Senior\ Manager Principal AVP Deputy\ Manager),
    leadership: ~w(Director VP Senior\ Director Head General\ Manager)
  }

  # Product categories
  @product_categories ~w(
    Electronics Clothing Footwear Home\ &\ Kitchen Beauty Sports Books
    Toys Automotive Health Grocery Jewelry Furniture Office Garden
  )

  # Brands (Indian + International)
  @brands ~w(
    Samsung Apple OnePlus Xiaomi Realme Vivo Oppo Sony LG HP Dell
    Lenovo Asus Boat JBL Nike Adidas Puma Reebok Woodland Bata
    Tanishq Titan Fastrack Casio Fossil Raymond Peter\ England Allen\ Solly
    Van\ Heusen Louis\ Philippe Park\ Avenue Fabindia W Biba Global\ Desi
  )

  # Order/Invoice statuses
  @order_statuses ~w(pending confirmed shipped delivered cancelled)
  @payment_statuses ~w(pending paid refunded partially_paid)
  @invoice_statuses ~w(draft sent paid overdue cancelled)

  # Lead sources and stages
  @lead_sources ~w(Website Referral LinkedIn Facebook Instagram Trade\ Show Cold\ Call Email\ Campaign Google\ Ads Partner)
  @lead_stages ~w(New Contacted Qualified Proposal Negotiation Won Lost)

  # Project types and statuses
  @project_types ~w(Web\ App Mobile\ App API\ Development Consulting Data\ Analytics Cloud\ Migration DevOps E-commerce CRM ERP)
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

  def random_product_category, do: Enum.random(@product_categories)
  def random_brand, do: Enum.random(@brands)
  def random_order_status, do: Enum.random(@order_statuses)
  def random_payment_status, do: Enum.random(@payment_statuses)
  def random_invoice_status, do: Enum.random(@invoice_statuses)
  def random_lead_source, do: Enum.random(@lead_sources)
  def random_lead_stage, do: Enum.random(@lead_stages)
  def random_project_type, do: Enum.random(@project_types)
  def random_project_status, do: Enum.random(@project_statuses)

  def all_product_categories, do: @product_categories
  def all_brands, do: @brands
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

  def generate_product_name(category) do
    adjectives = ~w(Premium Essential Classic Modern Ultra Pro Elite Smart Advanced Basic)

    nouns =
      case category do
        "Electronics" ->
          ~w(Phone Laptop Tablet Watch Earbuds Speaker Camera Charger Cable Mouse Keyboard)

        "Clothing" ->
          ~w(Shirt T-Shirt Jeans Jacket Sweater Dress Kurta Saree Suit Blazer)

        "Footwear" ->
          ~w(Sneakers Sandals Boots Loafers Heels Flats Slippers Sports\ Shoes Formal\ Shoes)

        "Home & Kitchen" ->
          ~w(Mixer Blender Cooker Kettle Toaster Microwave Utensils Cookware Storage)

        "Beauty" ->
          ~w(Cream Serum Lotion Shampoo Conditioner Lipstick Foundation Mascara Perfume)

        "Sports" ->
          ~w(Bat Ball Racket Shoes Gloves Jersey Helmet Bag Equipment Gear)

        "Books" ->
          ~w(Novel Textbook Guide Manual Journal Notebook Planner Diary Magazine)

        "Toys" ->
          ~w(Car Doll Puzzle Game Robot Action\ Figure Board\ Game Building\ Blocks)

        _ ->
          ~w(Item Product Accessory Set Kit Pack Bundle Collection)
      end

    "#{Enum.random(adjectives)} #{Enum.random(nouns)}"
  end

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

  @doc """
  Formats amount in Indian currency format (₹X,XX,XXX.XX)
  """
  def format_inr(amount) when is_integer(amount) do
    format_inr(Decimal.new(amount))
  end

  def format_inr(%Decimal{} = amount) do
    amount
    |> Decimal.to_string()
    |> format_indian_number()
    |> then(&"₹#{&1}")
  end

  defp format_indian_number(str) do
    {decimal, integer} =
      case String.split(str, ".") do
        [int] -> {"", int}
        [int, dec] -> {"." <> dec, int}
      end

    integer
    |> String.reverse()
    |> String.graphemes()
    |> Enum.chunk_every(2, 2, [])
    |> Enum.with_index()
    |> Enum.map(fn {chunk, i} ->
      if i == 0, do: Enum.take(chunk ++ [""], 3), else: chunk
    end)
    |> List.flatten()
    |> Enum.join(",")
    |> String.reverse()
    |> String.trim_leading(",")
    |> Kernel.<>(decimal)
  end
end
