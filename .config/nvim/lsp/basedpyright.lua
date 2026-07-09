return {
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
                ignore = { "venv", ".venv" },
                diagnosticSeverityOverrides = {
                    reportArgumentType = "information",
                    reportAttributeAccessIssue = "information",
                    reportCallIssue = "information",
                    reportGeneralTypeIssues = "information",
                    reportInvalidTypeArguments = "information",
                    reportOperatorIssue = "information",
                    reportOptionalMemberAccess = "information",
                    reportOptionalSubscript = "information",
                },
            },
        },
    },
}
