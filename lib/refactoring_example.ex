defmodule RefactoringExample do
  @moduledoc """
  Public API for refactoring example
  """

  alias RefactoringExample.Listing
  alias RefactoringExample.WebsiteScraper

  @spec print_cars :: :ok
  def print_cars do
    get_listings()
    |> output_listings()
  end

  @spec get_listings() :: [Listing.t()]
  defp get_listings do
    "sedan"
    |> WebsiteScraper.get_listing_summaries()
    |> Enum.map(fn %{title: title, detail_page_url: detail_page_url} ->
      sellers_notes = WebsiteScraper.get_sellers_notes(detail_page_url)

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
end
