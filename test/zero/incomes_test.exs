defmodule Zero.IncomesTest do
  use Zero.DataCase

  alias Zero.Incomes

  describe "income" do
    alias Zero.Incomes.Income

    import Zero.IncomesFixtures

    @invalid_attrs %{income: nil}

    test "list_income/0 returns all income" do
      income = income_fixture()
      assert Incomes.list_income() == [income]
    end

    test "get_income!/1 returns the income with given id" do
      income = income_fixture()
      assert Incomes.get_income!(income.id) == income
    end

    test "create_income/1 with valid data creates a income" do
      valid_attrs = %{income: 42}

      assert {:ok, %Income{} = income} = Incomes.create_income(valid_attrs)
      assert income.income == 42
    end

    test "create_income/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Incomes.create_income(@invalid_attrs)
    end

    test "update_income/2 with valid data updates the income" do
      income = income_fixture()
      update_attrs = %{income: 43}

      assert {:ok, %Income{} = income} = Incomes.update_income(income, update_attrs)
      assert income.income == 43
    end

    test "update_income/2 with invalid data returns error changeset" do
      income = income_fixture()
      assert {:error, %Ecto.Changeset{}} = Incomes.update_income(income, @invalid_attrs)
      assert income == Incomes.get_income!(income.id)
    end

    test "delete_income/1 deletes the income" do
      income = income_fixture()
      assert {:ok, %Income{}} = Incomes.delete_income(income)
      assert_raise Ecto.NoResultsError, fn -> Incomes.get_income!(income.id) end
    end

    test "change_income/1 returns a income changeset" do
      income = income_fixture()
      assert %Ecto.Changeset{} = Incomes.change_income(income)
    end
  end
end
