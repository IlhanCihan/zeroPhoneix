defmodule Zero.Repo do
  use Ecto.Repo,
    otp_app: :zero,
    adapter: Ecto.Adapters.SQLite3
end
