
(
 (expression_statement
   (assignment
     right: (string
              (string_content) @sql))
   )
 (#contains? @sql "SELECT" "UPDATE" "DELETE" "INSERT" "CREATE" "ALTER" "DROP" "FROM" "BEGIN")
 )
