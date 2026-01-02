#!/usr/bin/env bash

INPUT="movies.json"
OUT_DIR="posters"

mkdir -p "$OUT_DIR"

if [[ ! -f "$INPUT" ]]; then
  echo "❌ File not found: $INPUT"
  exit 1
fi

echo "🎬 Downloading movie posters..."

jq -r '
  .[] 
  | select(.Poster != "N/A") 
  | [.Title, .imdbID, .Poster] 
  | @tsv
' "$INPUT" | while IFS=$'\t' read -r TITLE IMDB_ID URL; do

  # Sanitize filename
  SAFE_TITLE=$(echo "$TITLE" | tr ' /:' '_' | tr -cd '[:alnum:]_')
  FILE_NAME="${SAFE_TITLE}_${IMDB_ID}.jpg"

  echo "⬇️  $FILE_NAME"
  curl -s "$URL" -o "$OUT_DIR/$FILE_NAME"

done

echo "✅ Done"
echo "📁 Posters saved in: $OUT_DIR"
echo "🖼 Total downloaded: $(ls -1 "$OUT_DIR" | wc -l)"

