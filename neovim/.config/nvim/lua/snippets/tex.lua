---@diagnostic disable: undefined-global
return {
    s(
        "table",
        fmta(
            [[
            \begin{table}
                \caption{<caption>}
                \label{<label>}
                \centering
                \begin{tabular}{|l|l|l|} \hline
                    x & y $ z \\
                    \hline
                    a & b & c \\
                    \hline
                \end{tabular}
            \end{table}]],
            {
                caption = i(1),
                label = i(2),
            }
        )
    ),
}
