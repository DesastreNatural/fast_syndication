defmodule FastSyndicationTest do
  use ExUnit.Case
  doctest FastSyndication

  test "parsing atom feed" do
    assert :ok == FastSyndication.parse_atom(atom()) |> elem(0)
  end

  test "parsing rss feed" do
    assert :ok = FastSyndication.parse_rss(rss()) |> elem(0)
  end

  test "parsing an atom feed" do
    {_status, data} = FastSyndication.parse(atom())
    feed_type = data.feed_type
    assert feed_type == "atom"
  end

  test "parsing a rss feed" do
    {_status, data} = FastSyndication.parse(rss())
    feed_type = data.feed_type
    assert feed_type == "rss"
  end

  test "parsing planet lisp rss feed" do
    rss = File.read!("test/samples/rss-planetlisp.xml")
    {status, data} = FastSyndication.parse(rss)

    assert status == :ok &&
             data.feed_type == "rss" &&
             data.title == "Planet Lisp" &&
             data.description == "Planet Lisp" &&
             data.url == "http://planet.lisp.org/" &&
             data.language == "en" &&
             List.first(data.entries).title ==
               "Nicolas Hafner: Kandria enters beta - September Kandria Update" &&
             List.first(data.entries).link == "https://reader.tymoon.eu/article/415"
  end

  test "parsing planet haskell atom feed" do
    atom = File.read!("test/samples/atom-planethaskell.xml")
    {status, data} = FastSyndication.parse(atom)

    assert status == :ok &&
             data.feed_type == "atom" &&
             data.title == "Planet Haskell"
  end

  test "parsing a feed list of links" do
    links = get_links_list()
    results_debug = for link <- links, do: HTTPoison.get!(link, [], follow_redirect: true).body
    data_debug = for result <- results_debug, do: FastSyndication.parse(result)
    results = for result <- results_debug, do: FastSyndication.parse(result) |> elem(0) == :ok
    assert Enum.all?(results) == true
  end

  defp get_links_list() do
    File.read!("test/samples/links")
    |> String.replace("\r", "")
    |> String.split("\n", trim: true)
  end

  defp atom() do
    """
      <?xml version=\"1.0\"?>\n<feed xmlns=\"http://www.w3.org/2005/Atom\"><title>My Blog</title><id></id><updated>1970-01-01T00:00:00+00:00</updated><author><name>N. Blogger</name></author><entry><title>My first post!</title><id></id><updated>1970-01-01T00:00:00+00:00</updated><content>This is my first post</content></entry></feed>
    """
  end

  defp rss() do
    """
      <?xml version=\"1.0\" encoding=\"utf-8\"?><rss version=\"2.0\"><channel><title>My Blog</title><link>http://myblog.com</link><description>Where I write stuff</description><item><title>My first post!</title><link>http://myblog.com/post1</link><description><![CDATA[This is my first post]]></description></item></channel></rss>
    """
  end
end
