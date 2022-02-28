defmodule Spike.Database do
  use Amnesia

  defdatabase Database do
    deftable(
      Customer,
      [:email, :stripe_id, :name],
      type: :ordered_set,
      index: [:stripe_id]
    )
  end
end
