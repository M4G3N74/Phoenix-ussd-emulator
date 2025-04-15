defmodule UssdEmulatorWeb.UssdEmulatorLive do
  use UssdEmulatorWeb, :live_view
  alias UssdEmulator.Ussd.Service

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "USSD Emulator",
      display_text: "Dial *123#, *456#, or *789# to start",
      input_value: "",
      session_id: generate_session_id(),
      session_active: false,
      mobile_number: "",
      history: [],
      keyboard_mode: "123"
    )}
  end

  @impl true
  def handle_event("keypad-press", %{"key" => key}, socket) do
    input = socket.assigns.input_value

    new_input = case key do
      "clear" -> ""
      "backspace" -> if String.length(input) > 0, do: String.slice(input, 0..-2), else: ""
      _ -> input <> key
    end

    # Update display text based on input
    display_text = cond do
      # If we're entering a USSD code
      (socket.assigns.display_text == "Dial *123#, *456#, or *789# to start" ||
       socket.assigns.display_text == "Session cancelled. Dial *123#, *456#, or *789# to start" ||
       socket.assigns.display_text == "Please enter a valid USSD code (e.g. *123#)" ||
       socket.assigns.display_text == "Please enter a valid USSD code (e.g. *123#, *456#, or *789#)") &&
       String.starts_with?(new_input, "*") ->
        "Dialing " <> new_input
      # If we're dialing and backspaced to empty
      String.starts_with?(socket.assigns.display_text, "Dialing ") && new_input == "" ->
        "Dial *123#, *456#, or *789# to start"
      # If we're dialing and backspaced but still have input
      String.starts_with?(socket.assigns.display_text, "Dialing ") && String.starts_with?(new_input, "*") ->
        "Dialing " <> new_input
      # Otherwise keep the current display text
      true ->
        socket.assigns.display_text
    end

    {:noreply, assign(socket, input_value: new_input, display_text: display_text)}
  end

  @impl true
  def handle_event("switch-keyboard", %{"mode" => mode}, socket) do
    {:noreply, assign(socket, keyboard_mode: mode)}
  end

  @impl true
  def handle_event("send", _params, %{assigns: %{input_value: input}} = socket) do
    cond do
      # Starting a new session with a USSD code
      String.match?(input, ~r/^\*\d+#$/) ->
        {:noreply,
          socket
          |> assign(
            display_text: Service.process_ussd_code(input),
            session_active: true,
            history: [input | socket.assigns.history],
            input_value: ""
          )
        }

      # Continuing an active session
      socket.assigns.session_active ->
        response = Service.process_response(input, socket.assigns.history)

        # Check if session should end
        {session_active, display_text} =
          if String.contains?(response, "END") do
            {false, String.replace(response, "END", "")}
          else
            {true, response}
          end

        {:noreply,
          socket
          |> assign(
            display_text: display_text,
            session_active: session_active,
            history: [input | socket.assigns.history],
            input_value: ""
          )
        }

      # Invalid input when no session is active
      true ->
        {:noreply,
          socket
          |> assign(
            display_text: "Please enter a valid USSD code (e.g. *123#, *456#, or *789#)",
            input_value: ""
          )
        }
    end
  end

  @impl true
  def handle_event("set-mobile", %{"mobile" => mobile}, socket) do
    {:noreply, assign(socket, mobile_number: mobile)}
  end

  @impl true
  def handle_event("cancel", _params, socket) do
    {:noreply,
      socket
      |> assign(
        display_text: "Session cancelled. Dial *123#, *456#, or *789# to start",
        session_active: false,
        history: [],
        input_value: ""
      )
    }
  end

  # Helper functions
  defp generate_session_id do
    :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
  end
end
