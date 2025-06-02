defmodule Demo.Seeds.Employees do
  alias Demo.HR

  def run do
    departments = ["Engineering", "Sales", "Marketing", "HR", "Finance"]
    levels = ["junior", "mid", "senior", "lead"]

    for _ <- 1..1000 do
      HR.create_employee(%{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        department: Enum.random(departments),
        salary: Decimal.new(:rand.uniform(100000)),
        start_date: Date.add(Date.utc_today(), -:rand.uniform(1000)),
        level: Enum.random(levels),
        active: :rand.uniform(10) > 1
      })
    end
  end
end
