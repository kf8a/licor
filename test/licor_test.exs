defmodule LicorTest do
  use ExUnit.Case
  doctest Licor

  test "finding the right port" do
    ports = %{
      "ttyAMA0" => %{},
      "ttyUSB0" => %{
        description: "US232R",
        manufacturer: "FTDI",
        product_id: 24_577,
        serial_number: "FTZ528MH",
        vendor_id: 1_027
      },
      "ttyUSB1" => %{
        description: "USB-Serial Controller D",
        manufacturer: "Prolific Technology Inc. ",
        product_id: 8_963,
        vendor_id: 1_659
      },
      "ttyUSB2" => %{
        description: "US232R",
        manufacturer: "FTDI",
        product_id: 24_577,
        serial_number: "FT2MOM44",
        vendor_id: 1_027
      },
      "ttyUSB3" => %{
        description: "US232R",
        manufacturer: "FTDI",
        product_id: 24_577,
        serial_number: "FT2MQPUI",
        vendor_id: 1_027
      }
    }

    {port, _ } = Licor.Reader.find_port(ports, "FT2MOM44")

    assert port == "ttyUSB2"
  end
end
