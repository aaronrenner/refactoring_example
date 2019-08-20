defmodule RefactoringExampleTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "print_cars/1 outputs to console" do
    output =
      capture_io(fn ->
        :ok = RefactoringExample.print_cars()
      end)

    assert output =~ "Seller's notes"
  end
end
