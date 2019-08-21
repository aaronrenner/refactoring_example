defmodule RefactoringExample do
  @moduledoc """
  Public API for refactoring example
  """

  alias RefactoringExample.Listing
  alias HTTPoison.Response

  @spec print_cars :: :ok
  def print_cars do
    get_listings()
    |> output_listings()
  end

  @spec get_listings() :: [Listing.t()]
  defp get_listings do
    "sedan"
    |> get_listing_summaries()
    |> Enum.map(fn %{title: title, detail_page_url: detail_page_url} ->
      {:ok, %Response{status_code: 200, body: vehicle_html}} =
        HTTPoison.get(detail_page_url, [], follow_redirect: true)

      sellers_notes =
        vehicle_html
        |> Floki.find(".details-section__seller-notes")
        |> Floki.text()
        |> String.trim()
        |> String.replace_leading("Seller's Notes", "")

      %Listing{
        url: detail_page_url,
        title: title,
        sellers_notes: sellers_notes
      }
    end)
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

  @spec get_listing_summaries(String.t()) :: [%{title: String.t(), detail_page_url: String.t()}]
  defp get_listing_summaries(body_style) do
    url = "https://www.cars.com/shopping/#{body_style}/"
    {:ok, %Response{status_code: 200, body: body}} = HTTPoison.get(url)

    body
    |> Floki.find(".shop-srp-listings__listing")
    |> Enum.map(fn listing_html ->
      detail_page_url =
        listing_html
        |> Floki.attribute("href")
        |> List.first()
        |> (&Kernel.<>("http://www.cars.com", &1)).()

      title = Floki.find(listing_html, ".listing-row__title") |> Floki.text() |> String.trim()

      %{detail_page_url: detail_page_url, title: title}
    end)
  end
end
