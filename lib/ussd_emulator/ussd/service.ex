defmodule UssdEmulator.Ussd.Service do
  @moduledoc """
  Service module for handling USSD requests and responses.
  This module provides functions for processing USSD codes and user inputs.
  """

  @doc """
  Process a USSD code and return the appropriate response.
  """
  def process_ussd_code(code) do
    case code do
      "*123#" -> welcome_menu()
      "*456#" -> banking_menu()
      "*789#" -> utility_menu()
      _ -> default_menu()
    end
  end

  @doc """
  Process a user response based on the previous menu.
  """
  def process_response(input, [previous_input | _] = history) do
    cond do
      String.starts_with?(previous_input, "*123#") -> process_general_menu(input, history)
      String.starts_with?(previous_input, "*456#") -> process_banking_menu(input, history)
      String.starts_with?(previous_input, "*789#") -> process_utility_menu(input, history)
      true -> process_default_menu(input, history)
    end
  end

  # Private helper functions for different menus

  defp welcome_menu do
    """
    Welcome to USSD Emulator
    1. Check Balance
    2. Send Money
    3. Buy Airtime
    4. Pay Bills
    0. Exit
    """
  end

  defp banking_menu do
    """
    Mobile Banking
    1. Account Balance
    2. Mini Statement
    3. Funds Transfer
    4. Loan Services
    0. Exit
    """
  end

  defp utility_menu do
    """
    Utility Services
    1. Electricity
    2. Water
    3. TV Subscription
    4. Internet
    0. Exit
    """
  end

  defp default_menu do
    """
    Welcome to USSD Emulator
    1. Service Information
    2. Help
    0. Exit
    """
  end

  # Process responses for general menu
  defp process_general_menu("1", _history) do
    """
    Your balance is:
    $1,250.00

    1. Back to Main Menu
    0. Exit
    """
  end

  defp process_general_menu("2", _history) do
    """
    Send Money
    1. To Mobile Number
    2. To Bank Account
    3. To Wallet
    0. Back
    """
  end

  defp process_general_menu("3", _history) do
    """
    Buy Airtime
    1. For Self
    2. For Others
    0. Back
    """
  end

  defp process_general_menu("4", _history) do
    """
    Pay Bills
    1. Electricity
    2. Water
    3. TV Subscription
    0. Back
    """
  end

  defp process_general_menu("0", _history) do
    "Thank you for using our service."
  end

  defp process_general_menu(_, _history) do
    """
    Invalid selection.

    1. Back to Main Menu
    0. Exit
    """
  end

  # Process responses for banking menu
  defp process_banking_menu("1", _history) do
    """
    Account Balance:
    Checking: $2,540.75
    Savings: $15,200.30

    1. Back to Banking Menu
    0. Exit
    """
  end

  defp process_banking_menu("2", _history) do
    """
    Mini Statement:
    - $120.50 (Grocery Store)
    - $45.00 (Pharmacy)
    - $9.99 (Subscription)
    + $2,500.00 (Salary)

    1. Back to Banking Menu
    0. Exit
    """
  end

  defp process_banking_menu("3", _history) do
    """
    Funds Transfer
    1. To Own Account
    2. To Other Bank
    3. International Transfer
    0. Back
    """
  end

  defp process_banking_menu("4", _history) do
    """
    Loan Services
    1. Check Eligibility
    2. Apply for Loan
    3. Check Loan Status
    0. Back
    """
  end

  defp process_banking_menu("0", _history) do
    "Thank you for using Mobile Banking."
  end

  defp process_banking_menu(_, _history) do
    """
    Invalid selection.

    1. Back to Banking Menu
    0. Exit
    """
  end

  # Process responses for utility menu
  defp process_utility_menu("1", _history) do
    """
    Electricity Payment
    1. Pay Bill
    2. Check Balance
    3. Purchase Token
    0. Back
    """
  end

  defp process_utility_menu("2", _history) do
    """
    Water Bill Payment
    1. Pay Bill
    2. Check Balance
    0. Back
    """
  end

  defp process_utility_menu("3", _history) do
    """
    TV Subscription
    1. Pay Subscription
    2. Upgrade Package
    0. Back
    """
  end

  defp process_utility_menu("4", _history) do
    """
    Internet Services
    1. Pay Bill
    2. Check Data Balance
    3. Buy Data Bundle
    0. Back
    """
  end

  defp process_utility_menu("0", _history) do
    "END Thank you for using Utility Services."
  end

  defp process_utility_menu(_, _history) do
    """
    Invalid selection.

    1. Back to Utility Menu
    0. Exit
    """
  end

  # Process responses for default menu
  defp process_default_menu("1", _history) do
    """
    Service Information
    This is a USSD emulator for
    testing and demonstration.

    1. Back to Main Menu
    0. Exit
    """
  end

  defp process_default_menu("2", _history) do
    """
    Help
    For assistance, please
    contact support at:
    support@ussd-emulator.com

    1. Back to Main Menu
    0. Exit
    """
  end

  defp process_default_menu("0", _history) do
    "END Thank you for using our service."
  end

  defp process_default_menu(_, _history) do
    """
    Invalid selection.

    1. Back to Main Menu
    0. Exit
    """
  end
end
