defmodule FastSyndication.Normalization do
  alias FastSyndication.Feed
  alias FastSyndication.Entry

  def normalize_feed({:ok, :rss, data}) do
    atom_link =
      if data["extension"]["atom"]["link"] != nil do
        Enum.find(data["links"], nil, fn x -> x["rel"] == "self" end)["href"]
      else
        nil
      end

    {:ok,
     %Feed{
       feed_type: "rss",
       title: data["title"],
       description: data["description"],
       url:
         if atom_link != nil do
           atom_link
         else
           data["link"]
         end,
       #
       image: data["image"],
       categories: data["categories"],
       language: data["language"],
       updated_at: data["last_build_date"],
       entries: normalize_entries(data["items"], :rss)
     }}
  end

  def normalize_feed({:ok, :atom, data}) do
    atom_link =
      if data["links"] != nil do
        Enum.find(data["links"], nil, fn x -> x["rel"] == "self" end)["href"]
      else
        nil
      end

    {:ok,
     %Feed{
       feed_type: "atom",
       title: data["title"]["value"],
       description: data["description"],
       url:
         if atom_link != nil do
           atom_link
         else
           data["link"]
         end,
       #
       image: data["logo"],
       categories: data["categories"],
       language: data["lang"],
       updated_at: data["updated"],
       entries: normalize_entries(data["entries"], :atom)
     }}
  end

  def normalize_feed({:error, error_data}) do
    {:error, error_data}
  end

  defp normalize_entry(entry, :rss) do
    categories =
      if is_nil(entry["categories"]) do
        []
      else
        if is_list(entry["categories"]) do
          for category <- entry["categories"], do: category["name"]
        else
          []
        end
      end

    %Entry{
      title: entry["title"],
      link: entry["link"],
      summary: entry["description"],
      content: entry["content"],
      media: entry["enclosure"],
      author: entry["author"],
      categories: categories,
      published: entry["pub_date"]
    }
  end

  defp normalize_entry(entry, :atom) do
    # authors = if entry["authors"] != nil do Enum.find(entry["authors"],nil,fn x -> x["rel"] == "self" end)["href"] else nil end]
    entry_link =
      if entry["links"] != nil do
        Enum.find(entry["links"], nil, fn x -> x["rel"] == "self" end)["href"]
      else
        nil
      end

    categories =
      if is_nil(entry["categories"]) do
        []
      else
        if is_list(entry["categories"]) do
          for category <- entry["categories"], do: category["term"]
        else
          []
        end
      end

    %Entry{
      title: entry["title"]["value"],
      link: entry_link,
      summary: entry["summary"]["value"],
      content: entry["content"]["value"],
      media: nil,
      author: entry["authors"],
      categories: categories,
      published: entry["pub_date"]
    }
  end

  def normalize_entries(entries, :rss) when is_list(entries) do
    for entry <- entries, do: normalize_entry(entry, :rss)
  end

  def normalize_entries(entries, :atom) when is_list(entries) do
    for entry <- entries, do: normalize_entry(entry, :atom)
  end

  def normalize_entries(_, _), do: []
end
