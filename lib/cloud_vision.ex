defmodule CloudVision do
  @features [label: "LABEL_DETECTION", logo: "LOGO_DETECTION", text: "TEXT_DETECTION",
   face: "FACE_DETECTION", landmark: "LANDMARK_DETECTION", safe_search: "SAFE_SEARCH_DETECTION",
   image_properties: "IMAGE_PROPERTIES", unspecified: "TYPE_UNSPECIFIED"
 ]

  @doc """
  Args:
    * `img_path` - relative path to the image file from local directory or root of google cloud storage
    * `options` - Keyword list of options

  Options:
    * `:from` - where to find the file. It can be `:storage` or `:local`. Default is `:local`
    * `:features` - list of detection features you want to use (`@features`)
  """
  def analyze(img_path, opts \\ []) do
    case CloudVision.Client.post("/images:annotate", build_params(img_path, opts) |> Poison.encode!) do
      {:ok, %HTTPoison.Response{status_code: x, body: body}} when x in 200..299 ->
        decoded = Poison.decode!(body)

        # handling error here because somehow the api returns status code 200 even an error occurs
        case decoded["responses"] |> Enum.find(fn (x) -> match? %{"error" => _}, x end) do
          %{"error" => %{"message" => msg}} -> {:error, msg}
          nil -> {:ok, decoded}
        end
      {:ok, %HTTPoison.Response{body: body}} -> {:error, Poison.decode!(body)}
      {:error, _} -> {:error, "Something went wrong"}
    end
  end

  @doc """
  iex> CloudVision.build_params("cat.jpg", from: :storage, features: [:image_properties])
  %{requests: [%{features: [%{type: "IMAGE_PROPERTIES"}],
     image: %{source: %{gcsImageUri: "gs://dummy.appspot.com/cat.jpg"}}}]}
  """
  def build_params(img_path, opts), do:
    %{requests: [%{image: build_image(img_path, opts[:from]), features: build_features(opts[:features])}]}

  defp build_image(img_path, nil), do: build_image(img_path, :local)
  defp build_image(img_path, :stream) do
    IO.puts "**********************"
    IO.inspect img_path
    IO.puts ">>>>>>>>>>>>>>>>>>>"
    {:ok, %Token{token: token}} = Token.for_scope("https://www.googleapis.com/auth/cloud-platform")
    IO.puts "********************** #{inspect token}"

    %{content: Base.encode64(img_path)}
  end
  defp build_image(img_path, :local), do: %{content: Base.encode64(File.read!(img_path))}
  defp build_image(img_path, :storage), do:
    %{source: %{
      gcsImageUri: "gs://" <> Application.get_env(:cloud_vision, :gcsUri) <> "/" <> img_path
    }}

  defp build_features(nil), do: build_features([])
  defp build_features([]), do: [%{type: @features[:unspecified]}]
  defp build_features(features), do: features |> Enum.map(&(%{type: @features[&1]}))
end
