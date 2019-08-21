defmodule RefactoringExample do
  @moduledoc """
  Public API for refactoring example
  """

  alias RefactoringExample.Listing
  alias HTTPoison.Response

  @spec print_cars :: :ok
  def print_cars do
    url = "https://www.cars.com/shopping/sedan/"
    {:ok, %Response{status_code: 200, body: body}} = HTTPoison.get(url)

    body
    |> Floki.find(".shop-srp-listings__listing")
    |> Enum.map(fn listing_html ->
      path = Floki.attribute(listing_html, "href") |> List.first()
      url = "http://www.cars.com#{path}"
      title = Floki.find(listing_html, ".listing-row__title") |> Floki.text() |> String.trim()

      {:ok, %Response{status_code: 200, body: vehicle_html}} =
        HTTPoison.get(url, [], follow_redirect: true)

      sellers_notes =
        vehicle_html
        |> Floki.find(".details-section__seller-notes")
        |> Floki.text()
        |> String.trim()
        |> String.replace_leading("Seller's Notes", "")

      %Listing{
        url: url,
        title: title,
        sellers_notes: sellers_notes
      }
    end)
    |> output_listings()
  end

  @spec output_listings([Listing.t()]) :: :ok
  defp output_listings(listings) when is_list(listings) do
    listings
    |> Enum.map(fn listing ->
      [
        "Title: #{listing.title}",
        "Seller's notes:",
        listing.sellers_notes,
        "",
        "Source: #{listing.url}"
      ]
    end)
    |> Enum.intersperse("\n-----\n")
    |> List.flatten()
    |> Enum.each(&IO.puts/1)
  end
end
