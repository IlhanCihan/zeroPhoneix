defmodule Zero.Repo.Migrations.CreateEnvelopes do
  use Ecto.Migration

  def change do
    create table(:envelopes) do
      add :name, :string
      add :balance, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
