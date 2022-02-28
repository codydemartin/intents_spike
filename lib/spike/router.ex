defmodule Spike.Router do
  use Plug.Router
  alias Spike.Database.Database.Customer

  plug(Plug.Static,
    at: "/",
    from: :spike,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)
  )

  plug(Plug.Parsers,
    parsers: [:json, :urlencoded],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  @template_dir "lib/spike/views"

  get "/" do
    conn
    |> put_status(200)
    |> render("customer_info.html")
  end

  post "/customer" do
    email = conn.body_params["email"]
    name = conn.body_params["name"]

    %Customer{
      stripe_id: stripe_customer_id
    } = Spike.Customers.find_or_create(email, name)

    {:ok, setup_intent} = Stripe.SetupIntent.create(%{customer: stripe_customer_id})

    conn
    |> put_status(200)
    |> render("test.html", client_secret: setup_intent.client_secret)
  end

  get "/update_customer" do
    conn
    |> put_status(200)
    |> render("redirect.html")
  end

  post "/update_customer" do
    IO.inspect(conn.body_params)

    %{
      "id" => id,
      "payment_method" => payment_method
    } = conn.body_params["setupIntent"]

    {_, customer} = Spike.Customers.get_customer_from_intent(id)
    {_, response} = Spike.Customers.make_default_payment_method(customer, payment_method)
    IO.inspect(response)

    map = Map.from_struct(response)
    json_response = Jason.encode(map)

    # at the moment this does not handle the correct response because i was unsure of what data we would want returned
    conn
    |> Plug.Conn.send_resp(200, json_response)
  end

  defp render(%{status: status} = conn, template, assigns \\ []) do
    body =
      @template_dir
      |> Path.join(template)
      |> String.replace_suffix(".html", ".html.eex")
      |> EEx.eval_file(assigns)

    send_resp(conn, status || 200, body)
  end
end
