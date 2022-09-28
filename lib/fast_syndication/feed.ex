# https://docs.rs/feed-rs/1.1.0/feed_rs/model/struct.Feed.html

#   RSS
# %{
#     #"categories" => [],
#     "cloud" => nil,
#     "copyright" => nil,
#     "description" => "Where I write stuff",
#     "docs" => nil,
#     "dublin_core_ext" => nil,
#     "extensions" => %{},
#     "generator" => nil,
#     "image" => nil,
#     "items" => [],
#     "itunes_ext" => nil,
#     "language" => nil,
#     "last_build_date" => nil,
#     "link" => "http://myblog.com",
#     "managing_editor" => nil,
#     "namespaces" => %{},
#     "pub_date" => nil,
#     "rating" => nil,
#     "skip_days" => [],
#     "skip_hours" => [],
#     "syndication_ext" => nil,
#     "text_input" => nil,
#     "title" => "My Blog",
#     "ttl" => nil,
#     "webmaster" => nil
#   }

#   ATOM
#   .%{
#     "authors" => [%{"email" => nil, "name" => "N. Blogger", "uri" => nil}],
#     "base" => nil,
#     #"categories" => [],
#     "contributors" => [],
#     "entries" => [],
#     "extensions" => %{},
#     "generator" => nil,
#     "icon" => nil,
#     "id" => "",
#     "lang" => nil,
#     "links" => [],
#     "logo" => nil,
#     "namespaces" => %{},
#     "rights" => nil,
#     "subtitle" => nil,
#     "title" => %{
#       "base" => nil,
#       "lang" => nil,
#       "type" => "Text",
#       "value" => "My Blog"
#     },
#     "updated" => "1970-01-01T00:00:00+00:00"
#   }
# categories
# logo - image

defmodule FastSyndication.Feed do
    
    defstruct [
        feed_type: nil,
        title: nil,
        description: nil,
        url: nil,
        image: nil,
        categories: [],
        language: nil,
        updated_at: nil,
        entries: []
    ]

end