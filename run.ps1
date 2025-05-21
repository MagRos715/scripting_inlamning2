# Din API-nyckel från TMDB


# Fråga användaren efter filmtitel
$movieTitle = Read-Host "Skriv in en filmtitel"

# Skapa sök-URL
$encodedTitle = [System.Web.HttpUtility]::UrlEncode($movieTitle)
$url = "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$encodedTitle&language=sv-SE"

# Anropa API:t
$response = Invoke-RestMethod -Uri $url -Method Get

# Hämta första filmen (om någon finns)
if ($response.results.Count -eq 0) {
    Write-Host "Ingen film hittades för '$movieTitle'." -ForegroundColor Red
} else {
    $movie = $response.results[0]
    Write-Host "`n🎬 Titel: $($movie.title)"
    Write-Host "📅 Releasedatum: $($movie.release_date)"
    Write-Host "⭐ Betyg: $($movie.vote_average) av $($movie.vote_count) röster"
    Write-Host "`n📖 Beskrivning:`n$($movie.overview)`n"
    if ($movie.poster_path) {
        $posterUrl = "https://image.tmdb.org/t/p/w300$($movie.poster_path)"
        Write-Host "🖼️ Poster: $posterUrl"
    }
}
Import-Module "$PSScriptRoot\get.psm1"
