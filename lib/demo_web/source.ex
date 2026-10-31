defmodule DemoWeb.Source do
  @moduledoc """
  The excerpt of a demo's source shown in its Code tab: the functions that configure the table,
  without the module head, cell renderers and markup.
  """

  @skip ~w(render handle_event handle_info none sidebar)

  def read(file) do
    code = File.read!(file)
    lines = String.split(code, "\n")

    excerpt =
      lines
      |> blocks()
      |> Enum.map_join("\n\n", fn block ->
        block |> String.split("\n") |> Enum.map_join("\n", &String.replace_prefix(&1, "  ", ""))
      end)

    %{
      html: Makeup.highlight("# In your LiveView\n\n" <> excerpt),
      file: Path.relative_to_cwd(file),
      lines: length(lines)
    }
  end

  # Public functions that configure the table, each with the comments right above it.
  defp blocks(lines), do: blocks(lines, [], [])

  defp blocks([], _comments, acc), do: Enum.reverse(acc)

  defp blocks(["  #" <> _ = comment | rest], comments, acc),
    do: blocks(rest, comments ++ [comment], acc)

  defp blocks(["  def " <> signature = line | rest], comments, acc) do
    name = signature |> String.split(["(", ",", " "]) |> hd()

    {body, rest} =
      if String.ends_with?(line, " do"),
        do:
          Enum.split_while(rest, &(&1 != "  end")) |> then(fn {b, [e | r]} -> {b ++ [e], r} end),
        else: Enum.split_while(rest, &(&1 != ""))

    acc = if name in @skip, do: acc, else: [Enum.join(comments ++ [line | body], "\n") | acc]
    blocks(rest, [], acc)
  end

  defp blocks([_ | rest], _comments, acc), do: blocks(rest, [], acc)
end
