defmodule ZeroWeb.IncomeControllerTest do
  use ZeroWeb.ConnCase

  import Zero.IncomesFixtures

  @create_attrs %{income: 42}
  @update_attrs %{income: 43}
  @invalid_attrs %{income: nil}

  describe "index" do
    test "lists all income", %{conn: conn} do
      conn = get(conn, ~p"/income")
      assert html_response(conn, 200) =~ "Listing Income"
    end
  end

  describe "new income" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/income/new")
      assert html_response(conn, 200) =~ "New Income"
    end
  end

  describe "create income" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/income", income: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/income/#{id}"

      conn = get(conn, ~p"/income/#{id}")
      assert html_response(conn, 200) =~ "Income #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/income", income: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Income"
    end
  end

  describe "edit income" do
    setup [:create_income]

    test "renders form for editing chosen income", %{conn: conn, income: income} do
      conn = get(conn, ~p"/income/#{income}/edit")
      assert html_response(conn, 200) =~ "Edit Income"
    end
  end

  describe "update income" do
    setup [:create_income]

    test "redirects when data is valid", %{conn: conn, income: income} do
      conn = put(conn, ~p"/income/#{income}", income: @update_attrs)
      assert redirected_to(conn) == ~p"/income/#{income}"

      conn = get(conn, ~p"/income/#{income}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, income: income} do
      conn = put(conn, ~p"/income/#{income}", income: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Income"
    end
  end

  describe "delete income" do
    setup [:create_income]

    test "deletes chosen income", %{conn: conn, income: income} do
      conn = delete(conn, ~p"/income/#{income}")
      assert redirected_to(conn) == ~p"/income"

      assert_error_sent 404, fn ->
        get(conn, ~p"/income/#{income}")
      end
    end
  end

  defp create_income(_) do
    income = income_fixture()
    %{income: income}
  end
end
