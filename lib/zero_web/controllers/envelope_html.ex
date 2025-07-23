defmodule ZeroWeb.EnvelopeHTML do
  use ZeroWeb, :html

  embed_templates "envelope_html/*"

  @doc """
  Renders a envelope form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def envelope_form(assigns)
end
