return {
  {
    "yetone/avante.nvim",
    opts = {
      -- 1. Set the active provider
      provider = "gemini",

      -- 2. Define the provider configuration in the new "providers" table
      providers = {
        gemini = {
          model = "gemini-3-flash-preview", -- Updated to the latest fast model
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
          timeout = 30000, -- Timeout in milliseconds
          temperature = 0,
          max_tokens = 4096,
        },
      },
    },
  },
}
