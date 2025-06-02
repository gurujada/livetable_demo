Code.require_file("employees_seeds.ex", __DIR__)
Code.require_file("events_seeds.ex", __DIR__)
Code.require_file("post_seeds.ex", __DIR__)
Code.require_file("products_seeds.ex", __DIR__)
Code.require_file("registration_seeds.ex", __DIR__)
Code.require_file("weather_seeds.ex", __DIR__)

# Run seeds in order
Demo.Seeds.Products.run()
Demo.Seeds.Employees.run()
Demo.Seeds.Events.run()
Demo.Seeds.Posts.run()
Demo.Seeds.Registrations.run()
Demo.Seeds.Weather.run()

# Print summary
alias Demo.Repo
alias Demo.Catalog.{Category, Product, Supplier, Image}

IO.puts("""
Seeding complete!
Employees: #{Repo.aggregate(Demo.HR.Employee, :count)}
Events: #{Repo.aggregate(Demo.Events.Event, :count)}
Posts: #{Repo.aggregate(Demo.Timeline.Post, :count)}
Categories: #{Repo.aggregate(Category, :count)}
Suppliers: #{Repo.aggregate(Supplier, :count)}
Products: #{Repo.aggregate(Product, :count)}
Images: #{Repo.aggregate(Image, :count)}
Weather Records: #{Repo.aggregate(Demo.Weather.Record, :count)}
""")
