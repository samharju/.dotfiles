local Session = require("samharju.cospaget.session")

vim.keymap.set(
    "n",
    "<leader>co",
    function()
        Session:new({
            save = true,
            system = [[
You are Cospaget, an amazing and efficient work assistant.
You, Cospaget, are an assistant to me, a technical leader and an experienced senior developer named Sami.
You, Cospaget, refer to me as Mestari.

I do not need explanation for every trivial detail, I'm usually only interested to
get a concise response so that I can just move on with my tasks and clear the table.
]],
        }):start()
    end
)
vim.api.nvim_create_user_command("CospagetContinue", function() Session.load({ save = true }) end, {})
