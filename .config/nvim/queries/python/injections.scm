(
 (expression_statement
   [
    (assignment
      right: (string
               (string_content) @injection.content))
    (call 
      arguments: (argument_list 
                   (string 
                     (string_content) @injection.content))) 
    ]
   )
 (#any-contains? @injection.content "SELECT" "UPDATE" "DELETE" "INSERT" "CREATE" "ALTER" "DROP" "FROM" "BEGIN" "TABLE")
 (#set! injection.language "sql")
 )

