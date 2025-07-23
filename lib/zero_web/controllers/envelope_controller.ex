defmodule ZeroWeb.EnvelopeController do
  use ZeroWeb, :controller

  alias Zero.Envelopes
  alias Zero.Envelopes.Envelope
  alias Zero.Incomes

  def index(conn, _params) do
    envelopes = Envelopes.list_envelopes()
    income = Incomes.list_income() |> List.first()
    render(conn, :index, envelopes: envelopes, income: income)
  end

  def new(conn, _params) do
    changeset = Envelopes.change_envelope(%Envelope{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"envelope" => envelope_params}) do
    case Envelopes.create_envelope(envelope_params) do
      {:ok, envelope} ->
        conn
        |> put_flash(:info, "Envelope created successfully.")
        |> redirect(to: ~p"/envelopes/#{envelope}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
        
      {:error, error_message} when is_binary(error_message) ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: ~p"/envelopes")
    end
  end

  def show(conn, %{"id" => id}) do
    envelope = Envelopes.get_envelope!(id)
    render(conn, :show, envelope: envelope)
  end

  def edit(conn, %{"id" => id}) do
    envelope = Envelopes.get_envelope!(id)
    changeset = Envelopes.change_envelope(envelope)
    render(conn, :edit, envelope: envelope, changeset: changeset)
  end

  def update(conn, %{"id" => id, "envelope" => envelope_params}) do
    envelope = Envelopes.get_envelope!(id)

    case Envelopes.update_envelope(envelope, envelope_params) do
      {:ok, envelope} ->
        conn
        |> put_flash(:info, "Envelope updated successfully.")
        |> redirect(to: ~p"/envelopes/#{envelope}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, envelope: envelope, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    envelope = Envelopes.get_envelope!(id)
    {:ok, _envelope} = Envelopes.delete_envelope(envelope)

    conn
    |> put_flash(:info, "Envelope deleted successfully.")
    |> redirect(to: ~p"/envelopes")
  end

  def spend(conn, %{"id" => id}) do
    envelope = Envelopes.get_envelope!(id)
    changeset = Envelopes.change_spend(envelope)
    render(conn, :spend, envelope: envelope, changeset: changeset)
  end

  def process_spend(conn, %{"id" => id, "envelope" => envelope_params}) do
    envelope = Envelopes.get_envelope!(id)
    
    case Envelopes.spend_from_envelope(envelope, envelope_params) do
      {:ok, _envelope} ->
        conn
        |> put_flash(:info, "Spent successfully from envelope.")
        |> redirect(to: ~p"/envelopes")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :spend, envelope: envelope, changeset: changeset)
        
      {:error, error_message} when is_binary(error_message) ->
        conn
        |> put_flash(:error, error_message)
        |> redirect(to: ~p"/envelopes")
    end
  end
end
