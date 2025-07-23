defmodule ZeroWeb.EnvelopeControllerTest do
  use ZeroWeb.ConnCase

  import Zero.EnvelopesFixtures

  @create_attrs %{name: "some name", balance: 42}
  @update_attrs %{name: "some updated name", balance: 43}
  @invalid_attrs %{name: nil, balance: nil}

  describe "index" do
    test "lists all envelopes", %{conn: conn} do
      conn = get(conn, ~p"/envelopes")
      assert html_response(conn, 200) =~ "Listing Envelopes"
    end
  end

  describe "new envelope" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/envelopes/new")
      assert html_response(conn, 200) =~ "New Envelope"
    end
  end

  describe "create envelope" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/envelopes", envelope: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/envelopes/#{id}"

      conn = get(conn, ~p"/envelopes/#{id}")
      assert html_response(conn, 200) =~ "Envelope #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/envelopes", envelope: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Envelope"
    end
  end

  describe "edit envelope" do
    setup [:create_envelope]

    test "renders form for editing chosen envelope", %{conn: conn, envelope: envelope} do
      conn = get(conn, ~p"/envelopes/#{envelope}/edit")
      assert html_response(conn, 200) =~ "Edit Envelope"
    end
  end

  describe "update envelope" do
    setup [:create_envelope]

    test "redirects when data is valid", %{conn: conn, envelope: envelope} do
      conn = put(conn, ~p"/envelopes/#{envelope}", envelope: @update_attrs)
      assert redirected_to(conn) == ~p"/envelopes/#{envelope}"

      conn = get(conn, ~p"/envelopes/#{envelope}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, envelope: envelope} do
      conn = put(conn, ~p"/envelopes/#{envelope}", envelope: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Envelope"
    end
  end

  describe "delete envelope" do
    setup [:create_envelope]

    test "deletes chosen envelope", %{conn: conn, envelope: envelope} do
      conn = delete(conn, ~p"/envelopes/#{envelope}")
      assert redirected_to(conn) == ~p"/envelopes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/envelopes/#{envelope}")
      end
    end
  end

  defp create_envelope(_) do
    envelope = envelope_fixture()
    %{envelope: envelope}
  end
end
