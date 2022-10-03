defmodule FastSyndication do
  @moduledoc """
  Minimal wrapper around Rust NIFs for fast RSS and Atom feed parsing.
  """
  defmodule Native do
    @moduledoc false
    use Rustler, otp_app: :fast_syndication, crate: "fastsyndication"

    def parse_atom(_a), do: :erlang.nif_error(:nif_not_loaded)
    def parse_rss(_a), do: :erlang.nif_error(:nif_not_loaded)
  end

  @doc ~S"""
  Parse an atom string into a map.
  """
  def parse_atom(atom_string) when is_binary(atom_string) do
    atom_string
    |> Native.parse_atom()
    |> map_to_tuple()
  end

  def parse_atom(""), do: {:error, "Cannot parse blank string"}
  def parse_atom(_something_else), do: {:error, "RSS feed must be passed in as a string"}

  @doc ~S"""
  Parse an rss string into a map
  """
  def parse_rss(rss_string) when is_binary(rss_string) do
    rss_string
    |> Native.parse_rss()
    |> map_to_tuple()
  end

  def parse_rss(""), do: {:error, "Cannot parse blank string"}
  def parse_rss(_something_else), do: {:error, "RSS feed must be passed in as a string"}

  defp map_to_tuple(%{"Ok" => map}), do: {:ok, map}
  defp map_to_tuple({:ok, map}), do: {:ok, map}
  defp map_to_tuple(%{"Err" => msg}), do: {:error, msg}
  defp map_to_tuple({:error, msg}), do: {:error, msg}

  ###

  def recognize(data) do
    case parse_atom(data) do
      {:error, _atom_error} ->
        case parse_rss(data) do
          {:error, rss_error} ->
            {:error, "Can't recognize feed type: #{Kernel.inspect(rss_error)}"}

          {:ok, data} ->
            {:ok, :rss, data}
        end

      {:ok, data} ->
        {:ok, :atom, data}
    end
  end

  def parse(data) do
    # IO.inspect |>
    recognize(data)
    |> FastSyndication.Normalization.normalize_feed()
  end
end
