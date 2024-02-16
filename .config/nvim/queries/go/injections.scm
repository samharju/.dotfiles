; inject some sql

(
 (raw_string_literal) @sql (#offset! @sql 0 1 0 -1)
 (#contains? @sql "SELECT" "UPDATE" "DELETE" "INSERT" "CREATE" "ALTER" "DROP" "FROM" "BEGIN")
 )

(
 (interpreted_string_literal) @sql (#offset! @sql 0 1 0 -1)
 (#contains? @sql "SELECT" "UPDATE" "DELETE" "INSERT" "CREATE" "ALTER" "DROP" "FROM" "BEGIN")
 )
