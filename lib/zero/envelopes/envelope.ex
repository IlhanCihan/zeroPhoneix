defmodule Zero.Envelopes.Envelope do
  use Ecto.Schema
  import Ecto.Changeset

  schema "envelopes" do
    field :name, :string
    field :balance, :integer
    field :amount, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(envelope, attrs) do
    envelope
    |> cast(attrs, [:name, :balance])
    |> validate_required([:name, :balance])
  end

  @doc false
  def spend_changeset(envelope, attrs) do
    envelope
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than: 0)
  end
end
