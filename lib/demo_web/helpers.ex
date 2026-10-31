defmodule DemoWeb.Helpers do
  @moduledoc """
  Cell renderers the demos share: status pills, money and dates.
  """
  use Phoenix.Component

  @tones %{
    good: ~w(delivered paid completed active won),
    wait: ~w(new pending packed planning on_hold partially_paid negotiation),
    move: ~w(shipped confirmed contacted qualified proposal),
    stop: ~w(cancelled refunded lost discontinued),
    none: ~w(draft)
  }

  @tone_classes %{
    good: "bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400",
    wait: "bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400",
    move: "bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400",
    stop: "bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400",
    none: "bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-400"
  }

  @doc "A status pill, coloured by what the status means."
  attr :value, :string, required: true

  def pill(assigns) do
    value = String.downcase(assigns.value)
    tone = Enum.find_value(@tones, :none, fn {tone, words} -> value in words && tone end)
    assigns = assign(assigns, :class, @tone_classes[tone])

    ~H"""
    <span class={[
      "inline-flex items-center gap-1.5 px-2 py-1 text-xs rounded-full font-medium capitalize whitespace-nowrap",
      @class
    ]}>
      <span class="size-1.5 rounded-full bg-current"></span>
      {String.replace(@value, "_", " ")}
    </span>
    """
  end

  @avatars [
    "bg-cyan-500/15 text-cyan-600 dark:text-cyan-300",
    "bg-purple-500/15 text-purple-600 dark:text-purple-300",
    "bg-amber-500/15 text-amber-700 dark:text-amber-300",
    "bg-green-500/15 text-green-700 dark:text-green-300",
    "bg-pink-500/15 text-pink-600 dark:text-pink-300",
    "bg-blue-500/15 text-blue-600 dark:text-blue-300"
  ]

  @doc "A person or company: coloured initials, the name, and an optional second line."
  attr :name, :string, required: true
  attr :sub, :string, default: nil

  def person(assigns) do
    initials =
      assigns.name |> String.split() |> Enum.map_join(&String.first/1) |> String.slice(0, 2)

    assigns =
      assign(assigns,
        initials: initials,
        color: Enum.at(@avatars, :erlang.phash2(assigns.name, length(@avatars)))
      )

    ~H"""
    <div class="flex items-center gap-3">
      <span class={[
        "flex size-8 shrink-0 items-center justify-center rounded-full text-xs font-semibold",
        @color
      ]}>
        {@initials}
      </span>
      <div class="min-w-0">
        <div class="truncate font-medium text-foreground">{@name}</div>
        <div :if={@sub} class="truncate text-xs text-muted-foreground">{@sub}</div>
      </div>
    </div>
    """
  end

  @doc "Two lines: a main value and a muted one below it."
  attr :main, :any, required: true
  attr :sub, :any, default: nil
  attr :mono, :boolean, default: false

  def stacked(assigns) do
    ~H"""
    <div class="min-w-0">
      <div class="truncate font-medium text-foreground">{@main}</div>
      <div :if={@sub} class={["truncate text-xs text-muted-foreground", @mono && "font-mono"]}>
        {@sub}
      </div>
    </div>
    """
  end

  @doc "A small bar showing `value` out of `max`, with its colour."
  attr :value, :any, required: true
  attr :max, :any, required: true
  attr :color, :string, default: "bg-cyan-500"
  attr :label, :any, default: nil

  def meter(assigns) do
    value =
      if is_struct(assigns.value, Decimal),
        do: Decimal.to_float(assigns.value),
        else: assigns.value

    assigns = assign(assigns, :percent, min(100, round(value / max(assigns.max, 1) * 100)))

    ~H"""
    <div class="flex items-center gap-2">
      <div class="h-1.5 w-16 shrink-0 rounded-full bg-muted">
        <div class={["h-1.5 rounded-full", @color]} style={"width: #{@percent}%"}></div>
      </div>
      <span :if={@label} class="font-mono text-xs">{@label}</span>
    </div>
    """
  end

  @doc "A short relative time: today, yesterday, 5 days ago, 3 months ago."
  def relative(%Date{} = date), do: relative_days(Date.diff(Date.utc_today(), date))

  def relative(%DateTime{} = at),
    do: relative_days(DateTime.diff(DateTime.utc_now(), at, :day))

  defp relative_days(0), do: "today"
  defp relative_days(1), do: "yesterday"
  defp relative_days(days) when days < 0, do: "in #{-days} days"
  defp relative_days(days) when days < 60, do: "#{days} days ago"
  defp relative_days(days), do: "#{div(days, 30)} months ago"

  @doc "Renders a status as a pill; use as a field renderer."
  def status(value) do
    assigns = %{value: value}

    ~H"""
    <.pill value={@value} />
    """
  end

  @doc "Renders an amount in rupees, in green; use as a field renderer."
  def money(amount) do
    assigns = %{amount: format_currency(amount)}

    ~H"""
    <span class="font-mono font-medium text-green-700 dark:text-green-400">₹{@amount}</span>
    """
  end

  @doc "Renders a cost in rupees, muted."
  def cost(amount) do
    assigns = %{amount: format_currency(amount)}

    ~H"""
    <span class="font-mono text-muted-foreground">₹{@amount}</span>
    """
  end

  @doc "Renders a margin percentage: green from 40%, yellow from 20%, red below."
  def margin(nil), do: "-"

  def margin(value) do
    value = Decimal.to_float(value)
    assigns = %{value: value}

    ~H"""
    <span class={[
      "font-mono",
      @value >= 40 && "text-green-600 dark:text-green-400",
      (@value >= 20 and @value < 40) && "text-yellow-600 dark:text-yellow-400",
      @value < 20 && "text-red-600 dark:text-red-400"
    ]}>
      {:erlang.float_to_binary(@value, decimals: 1)}%
    </span>
    """
  end

  @doc "Renders a stock count as a badge: red when out, yellow when low."
  def stock(quantity) do
    assigns = %{quantity: quantity}

    ~H"""
    <span class={[
      "px-2 py-1 text-xs rounded-full font-mono",
      @quantity == 0 && "bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400",
      @quantity in 1..49 && "bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400",
      @quantity >= 50 && "bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400"
    ]}>
      {@quantity}
    </span>
    """
  end

  @doc "Renders a rating out of 5 with a star, coloured by how good it is."
  def rating(nil), do: "-"

  def rating(value) do
    value = Decimal.to_float(value)
    assigns = %{value: value}

    ~H"""
    <span class="inline-flex items-center gap-1">
      <span class={[
        "font-medium",
        @value >= 4.0 && "text-green-600 dark:text-green-400",
        (@value >= 3.0 and @value < 4.0) && "text-yellow-600 dark:text-yellow-400",
        @value < 3.0 && "text-red-600 dark:text-red-400"
      ]}>
        {:erlang.float_to_binary(@value, decimals: 1)}
      </span>
      <span class="text-yellow-500">★</span>
    </span>
    """
  end

  @doc "Renders a date as 31 Oct 2026; use as a field renderer."
  def date(nil), do: "-"
  def date(date), do: Calendar.strftime(date, "%d %b %Y")

  @doc "Renders a past time as its date and how long ago, red after 30 days."
  def ago(nil) do
    assigns = %{}

    ~H"""
    <span class="text-sm text-red-500 dark:text-red-400">Never</span>
    """
  end

  def ago(at) do
    assigns = %{at: at, days: DateTime.diff(DateTime.utc_now(), at, :day)}

    ~H"""
    <div class={@days > 30 && "text-red-600 dark:text-red-400"}>
      <div class="text-sm">{Calendar.strftime(@at, "%d %b %Y")}</div>
      <div class="text-xs text-muted-foreground">{@days} days ago</div>
    </div>
    """
  end

  @doc """
  Format a number as Indian Rupees with proper comma separators.
  Uses Indian numbering system (₹X,XX,XXX).

  Examples:
    format_currency(1234) => "1,234"
    format_currency(12345) => "12,345"
    format_currency(123456) => "1,23,456"
    format_currency(1234567) => "12,34,567"
  """
  def format_currency(nil), do: "-"

  def format_currency(amount) when is_struct(amount, Decimal) do
    amount
    |> Decimal.round(0)
    |> Decimal.to_integer()
    |> format_currency()
  end

  def format_currency(amount) when is_integer(amount) do
    sign = if amount < 0, do: "-", else: ""

    sign <> format_indian_number(abs(amount))
  end

  def format_currency(amount) when is_float(amount) do
    format_currency(trunc(amount))
  end

  defp format_indian_number(n) when n < 1000, do: Integer.to_string(n)

  defp format_indian_number(n) do
    # Get last 3 digits
    last_three = rem(n, 1000)
    rest = div(n, 1000)

    # Format the rest with 2-digit grouping (Indian system)
    rest_formatted = format_indian_rest(rest)

    # Pad last_three with zeros if needed
    last_three_str = last_three |> Integer.to_string() |> String.pad_leading(3, "0")

    "#{rest_formatted},#{last_three_str}"
  end

  defp format_indian_rest(n) when n < 100, do: Integer.to_string(n)

  defp format_indian_rest(n) do
    last_two = rem(n, 100)
    rest = div(n, 100)

    rest_formatted = format_indian_rest(rest)
    last_two_str = last_two |> Integer.to_string() |> String.pad_leading(2, "0")

    "#{rest_formatted},#{last_two_str}"
  end
end
