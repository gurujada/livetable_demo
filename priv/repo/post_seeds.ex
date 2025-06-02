defmodule Demo.Seeds.Posts do
  alias Demo.Timeline

  def run do
  posts = [
    %{
      body:
        "Just finished an incredible coding marathon! 💻 Learned so much about Elixir and Phoenix today.",
      likes_count: 42,
      repost_count: 7,
      photo_locations: ["uploads/coding_setup.jpg"]
    },
    %{
      body:
        "Beautiful morning hike in the mountains. Nature never fails to amaze me! The view from the top was absolutely breathtaking. 🏔️",
      likes_count: 89,
      repost_count: 15,
      photo_locations: ["uploads/mountain_view.jpg", "uploads/hiking_trail.jpg"]
    },
    %{
      body:
        "New recipe experiment: Vegan chocolate chip cookies that actually taste amazing! Who says healthy can't be delicious? 🍪",
      likes_count: 56,
      repost_count: 12,
      photo_locations: ["uploads/vegan_cookies.jpg"]
    },
    %{
      body:
        "Excited to announce my new open-source project on GitHub! A lightweight Phoenix LiveView dashboard. 🚀",
      likes_count: 73,
      repost_count: 21,
      photo_locations: ["uploads/github_project.png"]
    },
    %{
      body:
        "Conference day! Presenting my research on functional programming paradigms. Nervous but ready! 📊",
      likes_count: 34,
      repost_count: 5,
      photo_locations: ["uploads/conference_stage.jpg"]
    },
    %{
      body: "Random thought of the day: Why do we park in driveways but drive on parkways? 🤔",
      likes_count: 67,
      repost_count: 9,
      photo_locations: []
    },
    %{
      body:
        "Weekend project: Building a custom mechanical keyboard from scratch. Soldering, programming the firmware! 🛠️",
      likes_count: 95,
      repost_count: 18,
      photo_locations: ["uploads/keyboard_build1.jpg", "uploads/keyboard_build2.jpg"]
    },
    %{
      body: "Just completed my first marathon! 4 hours and 15 minutes of pure determination. 🏃‍♀️🏅",
      likes_count: 112,
      repost_count: 24,
      photo_locations: ["uploads/marathon_finish.jpg"]
    },
    %{
      body: "Debugging be like: Is it a feature or a bug? The eternal programmer's dilemma 😅",
      likes_count: 61,
      repost_count: 8,
      photo_locations: []
    },
    %{
      body:
        "Sunset photography session. Sometimes you just need to pause and appreciate the beauty around us. 🌅",
      likes_count: 103,
      repost_count: 16,
      photo_locations: ["uploads/sunset_photo.jpg"]
    }
  ]

    Enum.each(posts, fn post ->
      Timeline.create_post(post)
    end)
  end
end
