defmodule Zero.EnvelopesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zero.Envelopes` context.
  """

  @doc """
  Generate a envelope.
  """
  def envelope_fixture(attrs \\ %{}) do
    {:ok, envelope} =
      attrs
      |> Enum.into(%{
        balance: 42,
        name: "some name"
      })
      |> Zero.Envelopes.create_envelope()

    envelope
  end
end
