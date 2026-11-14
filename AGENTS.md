# Repository Guidelines

## Project Structure & Module Organization

This repository contains a Chinese-language Hexo 7 blog using the npm-installed Butterfly theme.

- `source/_posts/`: Markdown articles with YAML front matter.
- `source/about/`, `source/album/`, and other page directories: standalone pages.
- `source/_data/link.yml`: friend links; `source/img/` and `source/css_js/`: static assets.
- `scaffolds/`: templates for posts, drafts, and pages.
- `_config.yml`: site configuration; `_config.butterfly.yml`: theme overrides.
- `public/`: tracked generated site output. `db.json` and `node_modules/` are ignored.
- `themes/butterfly_old/`: legacy theme files; keep active theme customization in the root override file.

## Build, Test, and Development Commands

- `npm install`: install dependencies.
- `npm run server`: preview locally on port 4000.
- `npm run build`: generate the static site into `public/`.
- `npm run clean`: remove generated output and the Hexo cache.
- `npm run clean && npm run build`: regenerate from a clean state.
- `npx hexo new post "0214-example-title"`: scaffold an article; add its unique `id` afterward.

## Coding Style & Naming Conventions

Use two-space indentation for YAML and preserve surrounding formatting in existing assets. No formatter or linter is configured.

Name new posts with a four-digit prefix and descriptive slug, such as `0214-example-title.md`. Include `title`, `date`, `tags`, and a unique `id` in front matter; add `categories` when appropriate. Follow the site's `Asia/Shanghai` timezone.

Preserve existing article IDs because permalinks use `/archives/:id/`. Verify generated URLs before adding cross-links; existing links omit numeric leading zeros. Edit source files and regenerate output instead of hand-editing `public/`.

## Testing Guidelines

There is no automated test suite or coverage threshold. Validate changes with a clean build and local preview. Check affected articles, navigation, images, code blocks, and internal links; inspect mobile layouts for visual changes. Review generated diffs for unintended changes.

## Commit & Pull Request Guidelines

Recent commits use `feat:`, `fix:`, and `chore:` prefixes, usually with concise Chinese descriptions. Keep commits focused and include relevant regenerated `public/` files.

Pull requests should describe the change, list affected pages, report build and preview checks, and link relevant issues. Include screenshots for visual changes.

## Deployment & Configuration

Run `./deploy.sh "chore: 更新博客内容"` only for an explicitly requested deployment: it rebuilds and restarts `hexo-blog`, stages all changes, commits, rebases, and pushes to `main`. Check the working tree first. The Compose volume path is legacy NAS configuration; verify local mounts before use. Never commit credentials or private keys.
