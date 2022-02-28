defmodule Spike.Customers do
  require Amnesia
  require Amnesia.Helper
  require Exquisite
  require Spike.Database.Database.Customer

  alias Spike.Database.Database.Customer

  def create_customer(email, name) do
    new_customer = %{
      email: email,
      name: name
    }

    {:ok, %{id: stripe_customer_id} = _stripe_customer} = Stripe.Customer.create(new_customer)

    Amnesia.transaction do
      %Customer{stripe_id: stripe_customer_id, email: email, name: name}
      |> Customer.write()
    end
  end

  def get_customer(email) do
    Amnesia.transaction do
      Customer.read(email)
    end
    |> case do
      %Customer{} = customer -> customer
      _ -> {:error, :not_found}
    end
  end

  def find_or_create(email, name) do
    case Spike.Customers.get_customer(email) do
      %Customer{} = customer ->
        IO.puts("Found customer.")
        IO.inspect(customer)
        customer

      _ ->
        IO.puts("Creating new customer.")
        Spike.Customers.create_customer(email, name)
    end
  end

  def make_default_payment_method(customer_id, payment_method_id) do
    case Stripe.Customer.update(
           customer_id,
           %{invoice_settings: %{default_payment_method: payment_method_id}}
         ) do
      {:ok, customer} ->
        IO.inspect(customer)
        {:ok, customer}

      {:error, error} ->
        IO.puts(error.message)
        {:error, error}
    end
  end

  def get_customer_from_intent(setup_intent_id, params \\ %{}) do
    case Stripe.SetupIntent.retrieve(setup_intent_id, params) do
      {:ok,
       %Stripe.SetupIntent{
         customer: customer
       } = _result} ->
        {:ok, customer}

      {:error, error} ->
        {:error, error}
    end
  end
end
