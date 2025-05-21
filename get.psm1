function Get-MovieInfo {

    # Ladda nycklar från .env
    Get-Content .env | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            $name, $value = $matches[1], $matches[2]
            if (-not [System.Environment]::GetEnvironmentVariable($name)) {
                [System.Environment]::SetEnvironmentVariable($name, $value)
            }
        }
    }

    # Din API-nyckel från TMDB
    $apiKey = $env:apiKey

    # Fråga användaren efter filmtitel
    $movieTitle = Read-Host "Skriv in en filmtitel"
    $encodedTitle = [System.Web.HttpUtility]::UrlEncode($movieTitle)

    # Skapa URL och anropa API
    $url = "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$encodedTitle&language=sv-SE"
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get
    } catch {
        Write-Host "Fel vid anrop till TMDB API: $_" -ForegroundColor Red
        return
    }

    # Visa resultat
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
}
