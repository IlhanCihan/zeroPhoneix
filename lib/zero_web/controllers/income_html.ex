defmodule ZeroWeb.IncomeHTML do
  use ZeroWeb, :html

  embed_templates "income_html/*"

  @doc """
  Renders a income form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def income_form(assigns)
end
