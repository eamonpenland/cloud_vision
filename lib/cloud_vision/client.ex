defmodule CloudVision.Client do
  @moduledoc false

  use HTTPoison.Base
  alias Goth.Token

  def process_url(url) do
    "https://vision.googleapis.com/v1" <> url
  end

  def process_request_headers([]) do
    {:ok, token} = Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    IO.puts ",,,,,,,,,,,,,,,,,,,,,,,,,"
    IO.puts ",,,,,,,,,,,,,,,,,,,,,,,,,"
    IO.puts ",,,,,,,,,,,,,,,,,,,,,,,,,"
    IO.inspect token
    IO.puts ",,,,,,,,,,,,,,,,,,,,,,,,,"
    IO.puts ",,,,,,,,,,,,,,,,,,,,,,,,,"
    IO.puts ",,,,,,,,,,,,,,,,,,,,,,,,,"

    [{"Authorization", "Bearer " <> token}]
  end
end
