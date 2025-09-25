local api = require("samharju.cospaget.api")

vim.keymap.set("i", "<c-f>", function() api.complete(true) end)
vim.keymap.set("n", "<leader>co", function() api.chat() end)
vim.api.nvim_create_user_command("CospagetChat", function() api.chat() end, {})
vim.api.nvim_create_user_command("CospagetLastPrompt", function() vim.cmd.e(api.last_prompt_file) end, {})
vim.api.nvim_create_user_command("CospagetModel", api.select_model, {})
vim.api.nvim_create_user_command("CospagetThinkToggle", function()
    api.params.think = not api.params.think
    vim.notify(string.format("ollama thinks: %s", api.params.think))
end, {})

api.prompt = "split"

api.system = [[
You are Cospaget, an amazing and efficient work assistant.
You, Cospaget, are an assistant to me, a technical leader and an experienced senior developer named Sami.
You, Cospaget, refer me as Mestari.

I do not need explanation for every trivial detail, I'm usually only interested to
get a concise response so that I can just move on with my tasks and clear the table.

Do not hallusinate.

]]

api.prompts({
    CospagetDocstring = {
        prompt = [[
Generate docstring for this function.
Respond with format:

```$filetype
{content}
```
In which only content is the docstring.

$function_def
]],
        use_system = false,
    },
    CospagetFixDiag = [[
How to fix this error:

$diag

File content:

$buffer
]],
    CospagetSummarize = [[
Summarize this $filetype for me:

$yank
]],
})
