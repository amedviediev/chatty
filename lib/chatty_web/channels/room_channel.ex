defmodule ChattyWeb.RoomChannel do
  use ChattyWeb, :channel
  alias Chatty.Repo
  alias ChattyWeb.Presence
  alias Chatty.Coherence.User

  def join("room", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    user = Repo.get(User, socket.assigns.user_id)
    {:ok, _} = Presence.track(socket, user.name, %{online_at: inspect(System.system_time(:seconds))})
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("message:new", payload, socket) do
    user = Repo.get(User, socket.assigns.user_id)
    broadcast! socket, "message:new", %{user: user.name, message: payload["message"]}
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
