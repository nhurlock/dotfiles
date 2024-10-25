import { build } from 'esbuild'

await build({
  minify: true,
  bundle: true,
  platform: 'node',
  format: 'esm',
  entryPoints: ['server.ts'],
  outfile: 'dist/server.mjs',
  banner: {
    js: 'import { createRequire as topLevelCreateRequire } from \'module\';\nconst require = topLevelCreateRequire(import.meta.url);'
  }
})
