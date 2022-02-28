# Spike

Make sure to enter your credentials where needed. Secret key is needed in the config files, publishable key is needed in both the redirect.html.eex file as well as the test.html.eex file. Both of those files are located in the lib/views directory. 

1. mix deps.get
2. npm install
3. iex -S mix

If you run into problems with mnesia, try removing the database then recreating it. This can be done by:

1. rm -rf Mnesia.nonode@nohost
2. mix amnesia.create -d Spike.Database.Database --disk

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `spike` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spike, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/spike](https://hexdocs.pm/spike).

