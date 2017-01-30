defmodule RemoteRetro.RoomChannel do
  use RemoteRetro.Web, :channel
  alias RemoteRetro.Presence

  def join("room:lobby", _, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("new_idea", %{"body" => body}, socket) do
    broadcast! socket, "new_idea_received", %{body: body}
    {:noreply, socket}
  end
end