local lsp_handlers = require("user.plugins.config.lsp.handlers")
local on_attach = lsp_handlers.on_attach
local capabilities = lsp_handlers.capabilities

local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end

local home = os.getenv("HOME")
local workspace_path = home .. "/workspace/"
local os_type

if vim.fn.has("mac") == 1 then
  os_type = "mac"
elseif vim.fn.has("unix") == 1 then
  os_type = "linux"
else
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name
local jdtls_dir = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local java_properties = vim.fn.systemlist("java -XshowSettings:properties -version", nil, true)

if not java_properties then
  return
end

local java_home
local java_version
for _, line in ipairs(java_properties) do
  if line:match("java%.home") then
    java_home = line:gsub(".*java%.home = ", "")
  elseif line:match("java%.specification%.version") then
    java_version = line:gsub(".*java%.specification%.version = ", "")
  end
end

if not java_home or not java_version then
  return
end

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. jdtls_dir .. "/lombok.jar",
    "-jar", vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", jdtls_dir .. "/config_" .. os_type,
    "-data", workspace_dir
  },
  capabilities = capabilities,
  root_dir = root_dir,
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- or https://github.com/redhat-developer/vscode-java#supported-vs-code-settings
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          -- {
          --   name = "JavaSE-" .. java_version,
          --   path = java_home
          -- }
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
      format = {
        enabled = true,
      },
      import = {
        maven = {
          enabled = true
        }
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {},
    },
    contentProvider = { preferred = "fernflower" },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = {},
  },
}

config["on_attach"] = function(client, bufnr)
  pcall(vim.lsp.codelens.refresh)
  on_attach(client, bufnr)
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    pcall(vim.lsp.codelens.refresh)
  end,
})

jdtls.start_or_attach(config)
