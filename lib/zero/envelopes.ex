defmodule Zero.Envelopes do
  @moduledoc """
  The Envelopes context.
  """

  import Ecto.Query, warn: false
  alias Zero.Repo

  alias Zero.Envelopes.Envelope
  alias Zero.Incomes

  @doc """
  Returns the list of envelopes.

  ## Examples

      iex> list_envelopes()
      [%Envelope{}, ...]

  """
  def list_envelopes do
    Repo.all(Envelope)
  end

  @doc """
  Gets a single envelope.

  Raises `Ecto.NoResultsError` if the Envelope does not exist.

  ## Examples

      iex> get_envelope!(123)
      %Envelope{}

      iex> get_envelope!(456)
      ** (Ecto.NoResultsError)

  """
  def get_envelope!(id), do: Repo.get!(Envelope, id)

  @doc """
  Creates a envelope.

  ## Examples

      iex> create_envelope(%{field: value})
      {:ok, %Envelope{}}

      iex> create_envelope(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_envelope(attrs \\ %{}) do
    Repo.transaction(fn ->
      # Get the current income
      income = Incomes.list_income() |> List.first()
      
      if is_nil(income) do
        Repo.rollback("No income found. Please create an income first.")
      end
      
      # Check if there's enough income
      balance = case attrs["balance"] || attrs[:balance] do
        balance when is_binary(balance) -> String.to_integer(balance)
        balance when is_integer(balance) -> balance
        _ -> 0
      end
      
      IO.inspect(income.income, label: "Income amount")
      IO.inspect(balance, label: "Balance requested")
      IO.inspect(income.income < balance, label: "Is insufficient?")
      
      if income.income < balance do
        Repo.rollback("Insufficient income. Available: $#{income.income}, Requested: $#{balance}")
      end
      
      # Create the envelope
      envelope_result = %Envelope{}
      |> Envelope.changeset(attrs)
      |> Repo.insert()
      
      case envelope_result do
        {:ok, envelope} ->
          # Subtract the balance from income
          new_income_amount = income.income - balance
          income_update_result = Incomes.update_income(income, %{income: new_income_amount})
          
          case income_update_result do
            {:ok, _updated_income} -> envelope
            {:error, changeset} -> Repo.rollback(changeset)
          end
          
        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Updates a envelope.

  ## Examples

      iex> update_envelope(envelope, %{field: new_value})
      {:ok, %Envelope{}}

      iex> update_envelope(envelope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_envelope(%Envelope{} = envelope, attrs) do
    envelope
    |> Envelope.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a envelope.

  ## Examples

      iex> delete_envelope(envelope)
      {:ok, %Envelope{}}

      iex> delete_envelope(envelope)
      {:error, %Ecto.Changeset{}}

  """
  def delete_envelope(%Envelope{} = envelope) do
    Repo.delete(envelope)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking envelope changes.

  ## Examples

      iex> change_envelope(envelope)
      %Ecto.Changeset{data: %Envelope{}}

  """
  def change_envelope(%Envelope{} = envelope, attrs \\ %{}) do
    Envelope.changeset(envelope, attrs)
  end

  def change_spend(%Envelope{} = envelope, attrs \\ %{}) do
    Envelope.spend_changeset(envelope, attrs)
  end

  @doc """
  Spends money from an envelope by reducing its balance.
  """
  def spend_from_envelope(%Envelope{} = envelope, attrs) do
    Repo.transaction(fn ->
      # Extract the spend amount
      spend_amount = case attrs["amount"] || attrs[:amount] do
        amount when is_binary(amount) -> String.to_integer(amount)
        amount when is_integer(amount) -> amount
        _ -> 0
      end
      
      # Check if there's enough balance
      if envelope.balance < spend_amount do
        Repo.rollback("Insufficient balance in envelope. Available: $#{envelope.balance}, Requested: $#{spend_amount}")
      end
      
      # Update the envelope balance
      new_balance = envelope.balance - spend_amount
      envelope_update_result = update_envelope(envelope, %{balance: new_balance})
      
      case envelope_update_result do
        {:ok, updated_envelope} -> updated_envelope
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end
end
