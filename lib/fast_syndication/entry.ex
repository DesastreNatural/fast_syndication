#https://docs.rs/feed-rs/1.1.0/feed_rs/model/struct.Entry.html
defmodule FastSyndication.Entry do
    defstruct [
        title: nil,
        link: nil,
        summary: nil,
        content: nil,
        media: nil,
        author: nil,
        categories: nil,
        published: nil,
    ]
end