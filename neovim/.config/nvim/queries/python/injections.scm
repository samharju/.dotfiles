(
 (expression_statement
   (call 
     arguments: (argument_list 
                    [
                     (string
                       (string_content) @injection.content)
                     (concatenated_string 
                       (string
                         (string_content) @injection.content))
                     (_ 
                       (concatenated_string 
                          (string
                            (string_content) @injection.content)))
                    ]
                )
     ) 
   )
  (#any-contains? @injection.content "SELECT" "UPDATE" "DELETE" "INSERT" "CREATE" "ALTER" "DROP" "FROM" "BEGIN" "TABLE" "SHOW" "USE" )
 (#set! injection.language "sql")
 )

(
 (expression_statement
   (assignment
     left: (identifier) @var_name
     right: [
             (string
               (string_content) @injection.content)
             (concatenated_string 
               (string
                 (string_content) @injection.content))
             (_ 
               (concatenated_string 
                  (string
                    (string_content) @injection.content)))
            ]
     )
   )
 [
  (#any-contains? @injection.content "SELECT" "UPDATE" "DELETE" "INSERT" "CREATE" "ALTER" "DROP" "FROM" "BEGIN" "TABLE" "SHOW" "USE" )
  (#match? @var_name "_q$|_query$|stmt$")
  ]
 (#set! injection.language "sql")
 )
