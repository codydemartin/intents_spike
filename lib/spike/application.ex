defmodule Spike.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Spike.Router, options: [port: 4001])
    ]

    opts = [strategy: :one_for_one, name: Spike.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
