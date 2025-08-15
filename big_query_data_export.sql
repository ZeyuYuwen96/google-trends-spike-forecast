-- google_trends_last5years.sql
-- Pulls 5 years of weekly Google Trends data from BigQuery public dataset
-- Aggregates DMA-level scores into national weekly scores
-- Classifies terms into 'sports', 'streaming', or 'other'

WITH base AS (
  SELECT
    LOWER(term) AS term,
    week,
    score
  FROM `bigquery-public-data.google_trends.top_terms`
  WHERE dma_name IS NOT NULL
    AND week >= DATE_SUB(CURRENT_DATE(), INTERVAL 5 YEAR)
    AND REGEXP_CONTAINS(
      LOWER(term),
      r'(real madrid|ufc paramount|psg - tottenham|little league softball world series|'
      'barcelona - como|barcelona vs como|wsg tirol - real madrid|manchester united|'
      'daegu - barcelona|fc seoul vs barcelona|vissel kobe - barcelona|mlb trade deadline|'
      'ufc fight night|premier league summer series|premier league|mlb draft time|chelsea - psg|'
      'netflix|netflicks|disney\\+|disney plus|prime[ -]?video|amazon prime( video)?|'
      'hbo( |max)?|^max$|hulu|paramount\\+|paramount plus|peacock( tv)?|'
      'apple tv\\+|apple tv plus|espn\\+|espn plus|showtime|starz|crunchyroll|funimation|'
      'pluto tv|tubi|sling tv|roku channel)'
    )
)
SELECT
  term,
  week,
  SUM(score) AS weekly_score,
  CASE
    WHEN REGEXP_CONTAINS(term, r'(real madrid|ufc paramount|psg - tottenham|little league softball world series|'
                                 'barcelona - como|barcelona vs como|wsg tirol - real madrid|manchester united|'
                                 'daegu - barcelona|fc seoul vs barcelona|vissel kobe - barcelona|mlb trade deadline|'
                                 'ufc fight night|premier league summer series|premier league|mlb draft time|chelsea - psg)')
    THEN 'sports'

    WHEN REGEXP_CONTAINS(term, r'(netflix|netflicks|disney\\+|disney plus|prime[ -]?video|amazon prime( video)?|'
                                 'hbo( |max)?|^max$|hulu|paramount\\+|paramount plus|peacock( tv)?|'
                                 'apple tv\\+|apple tv plus|espn\\+|espn plus|showtime|starz|crunchyroll|funimation|'
                                 'pluto tv|tubi|sling tv|roku channel)')
    THEN 'streaming'
    ELSE 'other'
  END AS category
FROM base
GROUP BY term, week, category
ORDER BY category, term, week;
