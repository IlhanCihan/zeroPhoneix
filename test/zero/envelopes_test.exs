defmodule Zero.EnvelopesTest do
  use Zero.DataCase

  alias Zero.Envelopes

  describe "envelopes" do
    alias Zero.Envelopes.Envelope

    import Zero.EnvelopesFixtures

    @invalid_attrs %{name: nil, balance: nil}

    test "list_envelopes/0 returns all envelopes" do
      envelope = envelope_fixture()
      assert Envelopes.list_envelopes() == [envelope]
    end

    test "get_envelope!/1 returns the envelope with given id" do
      envelope = envelope_fixture()
      assert Envelopes.get_envelope!(envelope.id) == envelope
    end

    test "create_envelope/1 with valid data creates a envelope" do
      valid_attrs = %{name: "some name", balance: 42}

      assert {:ok, %Envelope{} = envelope} = Envelopes.create_envelope(valid_attrs)
      assert envelope.name == "some name"
      assert envelope.balance == 42
    end

    test "create_envelope/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Envelopes.create_envelope(@invalid_attrs)
    end

    test "update_envelope/2 with valid data updates the envelope" do
      envelope = envelope_fixture()
      update_attrs = %{name: "some updated name", balance: 43}

      assert {:ok, %Envelope{} = envelope} = Envelopes.update_envelope(envelope, update_attrs)
      assert envelope.name == "some updated name"
      assert envelope.balance == 43
    end

    test "update_envelope/2 with invalid data returns error changeset" do
      envelope = envelope_fixture()
      assert {:error, %Ecto.Changeset{}} = Envelopes.update_envelope(envelope, @invalid_attrs)
      assert envelope == Envelopes.get_envelope!(envelope.id)
    end

    test "delete_envelope/1 deletes the envelope" do
      envelope = envelope_fixture()
      assert {:ok, %Envelope{}} = Envelopes.delete_envelope(envelope)
      assert_raise Ecto.NoResultsError, fn -> Envelopes.get_envelope!(envelope.id) end
    end

    test "change_envelope/1 returns a envelope changeset" do
      envelope = envelope_fixture()
      assert %Ecto.Changeset{} = Envelopes.change_envelope(envelope)
    end
  end
end
