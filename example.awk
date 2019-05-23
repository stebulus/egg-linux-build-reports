# example of interpreting the output of flatten
BEGIN { FS = "\t" }
NR == 1 {
  for (i = 1; i <= NF; i++) field[i] = $i
  next
}
{ for (i in field) value[field[i]] = $i }

value["egg-linux-commit"] == commit {
  print value["result-checksum"], value["date"], \
    value["report"], value["build-machine/release"]
}
