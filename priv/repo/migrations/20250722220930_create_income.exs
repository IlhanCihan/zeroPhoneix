defmodule Zero.Repo.Migrations.CreateIncome do
  use Ecto.Migration

  def change do
    create table(:income) do
      add :income, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
