import times

const format = initTimeFormat "yyyy-MM-dd'T'HH:mm:ss'+00:00'"

proc parseUtcIso8601*(str: string): DateTime =
  try:
    times.parse(str, format, utc())
  except TimeParseError:
    echo "ERROR string was ", str
    raise
