# Repository Guidelines

## Project Structure & Module Organization
- `source/` holds all content: Markdown posts under `_posts/`, page folders, shared layouts in `_layouts/`, and includes in `_includes/`. Static assets live in `source/assets/`, `images/`, and `javascripts/`.
- `sass/` contains Compass-driven styles that compile into `source/stylesheets/`.
- `public/` is the generated site; never edit files here directly.
- `_deploy/` stores the GitHub Pages-ready branch after running deploy tasks.

## Build, Test, and Development Commands
- `bundle install` — install Ruby gems listed in `Gemfile`.
- `bundle exec rake generate` — build the static site into `public/`.
- `bundle exec rake watch` — rebuild when files in `source/` or `sass/` change.
- `bundle exec rake preview` — watch, compile, and serve on `http://localhost:4000/`.
- `bundle exec rake generate && bundle exec rake preview` — quick post-publish sanity check that rebuilds and serves in one step.
- `bundle exec rake deploy` — push the contents of `public/` to `_deploy/` for publishing.

## Coding Style & Naming Conventions
- Prefer two-space indentation for Ruby (`Rakefile`) and Sass.
- Name posts `YYYY-MM-DD-title.markdown`; the rake task `bundle exec rake new_post["My Title"]` handles this automatically.
- Keep YAML front matter minimal, quoting titles with special characters.
- For JavaScript and JSON fragments, follow existing camelCase naming, and keep lines under 100 characters.
- Run `bundle exec rake clean` before committing compiled CSS to avoid stale artifacts.
- When drafting posts, do not include the phrases `黑屋风`, `技术小黑屋风`, or `技术小黑屋` in the content.

## Testing Guidelines
- After content changes, run `bundle exec rake generate` and inspect the console for Jekyll warnings.
- Review the updated `public/` output locally in a browser, checking navigation and asset links.
- Use `bundle exec rake preview` during copy edits to validate redirects and forms.
- When altering Sass, confirm Compass recompiled `source/stylesheets/screen.css` and check for layout regressions on common breakpoints.

## Commit & Pull Request Guidelines
- Follow the existing Conventional Commit tone (`feat:`, `fix:`, `chore:`) seen in recent history.
- Scope commits narrowly; avoid bundling content updates with theme or config changes.
- In pull requests, link related issues, summarize the change, and add screenshots for visual tweaks.
- Mention any rake commands run for validation so reviewers can reproduce quickly.

## Deployment & Configuration Notes
- Adjust `_config.yml` for site-wide metadata, and `config.rb` for Compass settings.
- Update deploy credentials (`ssh_user`, `document_root`) in the `Rakefile` before first publish.
- Keep `CNAME` aligned with the configured domain; verify DNS before deploying changes.
