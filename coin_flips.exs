# Run as: iex --dot-iex path/to/notebook.exs

# Title: Coin Flip Process Analysis

# ── Random Coin Flips ──

num_flips = 300
random_coin_flips = 1..300 |> Enum.reduce("", fn _, acc -> acc <> <<Enum.random([?H, ?T])>> end)

center_has_run = fn graphemes ->
  first = hd(graphemes)
  last = graphemes |> Enum.reverse() |> hd
  center = graphemes |> tl |> Enum.reverse() |> tl

  center |> Enum.all?(&(&1 != last)) and
    center |> Enum.all?(&(&1 != first)) and
    center |> Enum.uniq() |> length == 1
end

count_runs_of_length = fn len, string ->
  string
  |> String.graphemes()
  |> List.insert_at(0, "X")
  |> Enum.reverse()
  |> List.insert_at(0, "X")
  |> Enum.chunk_every(len + 2, 1, :discard)
  |> Enum.reduce(0, fn x, acc ->
    if center_has_run.(x) do
      acc + 1
    else
      acc
    end
  end)
end

get_all_run_counts = fn flips ->
  1..String.length(flips)
  |> Enum.each(fn x ->
    count_of_runs = count_runs_of_length.(x, flips)

    if count_of_runs != 0 do
      IO.puts("#{x}: #{count_of_runs}")
    end
  end)
end

IO.puts(random_coin_flips)
get_all_run_counts.(random_coin_flips)

# ── Not-Entirely-Random Coin Flips ──

generate_next = fn curr, prob ->
  if :rand.uniform() <= prob do
    curr
  else
    if curr == "H" do
      "T"
    else
      "H"
    end
  end
end

gamma = 0.3

semi_random_coin_flips =
  1..299
  |> Enum.reduce(<<Enum.random([?H, ?T])>>, fn _, acc ->
    acc <> generate_next.(String.last(acc), gamma)
  end)

IO.puts(semi_random_coin_flips)
get_all_run_counts.(semi_random_coin_flips)
