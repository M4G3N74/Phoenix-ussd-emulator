defmodule UssdEmulatorWeb.UssdController do
  use UssdEmulatorWeb, :controller
  alias UssdEmulator.Ussd.Service

  def process(conn, params) do
    # Extract parameters from the request
    _phone_number = Map.get(params, "phoneNumber", "260123456789")
    _session_id = Map.get(params, "sessionId", "default_session")
    text = Map.get(params, "text", "")
    ussd_code = Map.get(params, "ussdCode", "*123#")

    # Process the USSD request
    response = process_ussd_request(text, ussd_code)

    # Return the response as JSON
    json(conn, %{message: response})
  end

  # Process the USSD request based on the input
  defp process_ussd_request("", ussd_code) do
    # Initial request (when user dials a USSD code)
    Service.process_ussd_code(ussd_code)
  end

  defp process_ussd_request(text, ussd_code) do
    # Follow-up request (user has selected an option)
    Service.process_response(text, [ussd_code])
  end
end
