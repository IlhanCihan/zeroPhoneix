defmodule Zero.IncomesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zero.Incomes` context.
  """

  @doc """
  Generate a income.
  """
  def income_fixture(attrs \\ %{}) do
    {:ok, income} =
      attrs
      |> Enum.into(%{
        income: 42
      })
      |> Zero.Incomes.create_income()

    income
  end
end
