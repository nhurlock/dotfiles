local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end

local home = os.getenv('HOME')
local workspace_path = home .. '/workspace/'
local os_type

if vim.fn.has('mac') == 1 then
  os_type = 'mac'
elseif vim.fn.has('unix') == 1 then
  os_type = 'linux'
else
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name
local jdtls_dir = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == '' then
  return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local versions_ok, jenv_versions = pcall(vim.fn.systemlist, 'jenv versions', nil, 0)
local paths_ok, java_home_paths = pcall(vim.fn.systemlist, 'readlink -f ~/.jenv/versions/*', nil, 0)

if not (versions_ok and paths_ok) then
  return
end

local runtimeI = -1 -- offset by 1 due to 'system'
local java_home_map = {}
local java_runtime = nil
local java_runtime_map = vim.fn.reduce(jenv_versions, function(acc, value)
  runtimeI = runtimeI + 1
  local parts = vim.fn.split(value, ' ', 0)
  local default = false
  local runtime
  if #parts >= 2 and string.match(value, '%* ') ~= nil then
    default = true
    runtime = parts[2]
    java_runtime = runtime
  else
    runtime = parts[1]
  end
  if string.match(runtime, '^[0-9.]+$') then
    local java_home = java_home_paths[runtimeI]
    if java_home ~= nil then
      java_home = vim.fn.trim(java_home)
      java_home_map[runtime] = java_home
      local name = 'JavaSE-' .. runtime
      if not acc[java_home] then
        acc[java_home] = {
          name = name,
          path = java_home,
          default = default,
        }
      else
        if #name < #acc[java_home].name then
          acc[java_home].name = name
        end
        if default then
          acc[java_home].default = true
        end
      end
    end
  end
  return acc
end, {})

if java_runtime == 'system' then
  local highest_java_runtime = vim.fn.max(vim.fn.keys(java_home_map))
  java_runtime = highest_java_runtime
  java_runtime_map[java_home_map[tostring(highest_java_runtime)]].default = true
end

local java_runtimes = vim.fn.values(java_runtime_map)

return {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.glob(jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    jdtls_dir .. '/config_' .. os_type,
    '-data',
    workspace_dir,
  },
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
        updateBuildConfiguration = 'interactive',
        detectJdksAtStart = true,
        runtimes = java_runtimes,
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
          enabled = 'all',
        },
      },
      format = {
        enabled = true,
        onType = {
          enabled = true,
        },
        settings = {
          profile = 'GoogleStyle',
          url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml',
        },
      },
      import = {
        maven = {
          enabled = true,
        },
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {},
    },
    contentProvider = { preferred = 'fernflower' },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
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
