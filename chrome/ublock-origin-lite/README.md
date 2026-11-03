# uBlock Origin Lite

Custom filters and configuration notes for [uBlock Origin Lite](https://github.com/uBlockOrigin/uBOL-home), a lightweight content blocker for Chromium-based browsers.

## Purpose

- Hide unnecessary UI elements on websites.
- Customize web application layouts using CSS filters.
- Minimize the number of installed browser extensions.
- Maintain reproducible browser configurations across machines.

## Setup

1. Install uBlock Origin Lite from the Chrome Web Store.
2. Set the default filtering mode to **Optimal**.
3. Grant the extension access to the required websites.
4. Open the extension dashboard and navigate to **Custom filters**.
5. Copy the contents of [`custom-filters.txt`](./custom-filters.txt) into the editor.
6. Save the changes and reload the affected pages.

## Custom Filters

### Notion

Target: `app.notion.com`

- Reduce page margins to 8px.
- Remove maximum-width restrictions on content blocks.
- Hide the floating Notion AI button.
- Preserve the functionality of the Notion editor.

These filters only modify the user interface. Hiding the AI button does not disable Notion AI itself.

The filters may require updates if Notion changes its DOM structure or CSS classes.

## Synchronization and Backup

- Custom filters are not automatically synchronized through Chrome Sync.
- [`custom-filters.txt`](./custom-filters.txt) is the source of truth and is maintained in this dotfiles repository.
- Apply the filters manually when setting up a new browser or machine.
- Use the extension's built-in backup and restore functionality when needed.
- Avoid committing complete extension backups, as they may contain site-specific settings or other potentially sensitive information.

## Maintenance

- Keep uBlock Origin Lite updated.
- Verify custom filters after major browser or website updates.
- Update `custom-filters.txt` whenever filters are added, modified, or removed.
- Keep site-specific rules grouped and documented in the filter file.
