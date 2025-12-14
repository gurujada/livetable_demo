defmodule DemoWeb.Helpers do
  @moduledoc """
  Shared helpers for demo views including currency formatting and common renderers.
  """

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
