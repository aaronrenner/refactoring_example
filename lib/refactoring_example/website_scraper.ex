defmodule RefactoringExample.WebsiteScraper do
  @moduledoc false

  alias HTTPoison.Response

  @spec get_listing_summaries(String.t()) :: [%{title: String.t(), detail_page_url: String.t()}]
  def get_listing_summaries(body_style) do
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

  @spec get_sellers_notes(String.t()) :: String.t()
  def get_sellers_notes(detail_page_url) do
    {:ok, %Response{status_code: 200, body: vehicle_html}} =
      HTTPoison.get(detail_page_url, [], follow_redirect: true)

    vehicle_html
    |> Floki.find(".details-section__seller-notes")
    |> Floki.text()
    |> String.trim()
    |> String.replace_leading("Seller's Notes", "")
  end
end
