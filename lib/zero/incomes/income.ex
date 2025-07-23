defmodule Zero.Incomes.Income do
  use Ecto.Schema
  import Ecto.Changeset

  schema "income" do
    field :income, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(income, attrs) do
    income
    |> cast(attrs, [:income])
    |> validate_required([:income])
  end
end
