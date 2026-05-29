return {
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
                ignore = { "venv" },
                diagnosticSeverityOverrides = {
                    reportGeneralTypeIssues = "information",
                    reportAttributeAccessIssue = "information",
                    reportArgumentType = "information",
                    reportCallIssue = "information",
                    reportOperatorIssue = "information",
                    reportInvalidTypeArguments = "information",
                    reportOptionalSubscript = "information",
                },
            },
        },
    },
}
