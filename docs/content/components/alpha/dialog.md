---
title: Dialog
componentId: dialog
status: Alpha
source: https://github.com/primer/view_components/tree/main/app/components/primer/alpha/dialog.rb
storybook: https://primer.style/view-components/stories/?path=/story/primer-alpha-dialog
---

import Example from '../../../src/@primer/gatsby-theme-doctocat/components/example'

<!-- Warning: AUTO-GENERATED file, do not edit. Add code comments to your Ruby instead <3 -->

Use `Dialog` for an overlayed dialog window.

## Arguments

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `title` | `String` | N/A | The title of the dialog. |
| `description` | `String` | `nil` | The optional description of the dialog. |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

## Slots

### `Buttons`

Optional list of buttons to be rendered.

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `system_arguments` | `Hash` | N/A | The same arguments as [Button](/components/button). |

### `Body`

Required body content.

| Name | Type | Default | Description |
| :- | :- | :- | :- |
| `system_arguments` | `Hash` | N/A | [System arguments](/system-arguments) |

## Examples

### Default

<Example src="<div role='dialog' aria-labelledby='dialog-8f8b4063' aria-describedby='dialog-description-8f8b4063' data-view-component='true'>  <header>    <h1 id='dialog-8f8b4063'>Title</h1>      <h2 id='dialog-description-8f8b4063'>Description</h2>    <button aria-label='Close' type='button' data-view-component='true' class='close-button'><svg aria-hidden='true' height='16' viewBox='0 0 16 16' version='1.1' width='16' data-view-component='true' class='octicon octicon-x'>    <path fill-rule='evenodd' d='M3.72 3.72a.75.75 0 011.06 0L8 6.94l3.22-3.22a.75.75 0 111.06 1.06L9.06 8l3.22 3.22a.75.75 0 11-1.06 1.06L8 9.06l-3.22 3.22a.75.75 0 01-1.06-1.06L6.94 8 3.72 4.78a.75.75 0 010-1.06z'></path></svg></button>    <button type='button' aria-label='Close'>      <svg aria-hidden='true' height='16' viewBox='0 0 16 16' version='1.1' width='16' data-view-component='true' class='octicon octicon-x'>    <path fill-rule='evenodd' d='M3.72 3.72a.75.75 0 011.06 0L8 6.94l3.22-3.22a.75.75 0 111.06 1.06L9.06 8l3.22 3.22a.75.75 0 11-1.06 1.06L8 9.06l-3.22 3.22a.75.75 0 01-1.06-1.06L6.94 8 3.72 4.78a.75.75 0 010-1.06z'></path></svg>    </button>  </header>    <footer>  </footer></div>" />

```erb
<%= render(Primer::Alpha::Dialog.new(
 title: "Title",
 description: "Description"
)) do |c| %>
  c.body do
    <em>Your custom content here</em>
  end
<% end %>
```

### With buttons

<Example src="<div role='dialog' aria-labelledby='dialog-8193a49f' aria-describedby='dialog-description-8193a49f' data-view-component='true'>  <header>    <h1 id='dialog-8193a49f'>Title</h1>      <h2 id='dialog-description-8193a49f'>Description</h2>    <button aria-label='Close' type='button' data-view-component='true' class='close-button'><svg aria-hidden='true' height='16' viewBox='0 0 16 16' version='1.1' width='16' data-view-component='true' class='octicon octicon-x'>    <path fill-rule='evenodd' d='M3.72 3.72a.75.75 0 011.06 0L8 6.94l3.22-3.22a.75.75 0 111.06 1.06L9.06 8l3.22 3.22a.75.75 0 11-1.06 1.06L8 9.06l-3.22 3.22a.75.75 0 01-1.06-1.06L6.94 8 3.72 4.78a.75.75 0 010-1.06z'></path></svg></button>    <button type='button' aria-label='Close'>      <svg aria-hidden='true' height='16' viewBox='0 0 16 16' version='1.1' width='16' data-view-component='true' class='octicon octicon-x'>    <path fill-rule='evenodd' d='M3.72 3.72a.75.75 0 011.06 0L8 6.94l3.22-3.22a.75.75 0 111.06 1.06L9.06 8l3.22 3.22a.75.75 0 11-1.06 1.06L8 9.06l-3.22 3.22a.75.75 0 01-1.06-1.06L6.94 8 3.72 4.78a.75.75 0 010-1.06z'></path></svg>    </button>  </header>    <footer>  </footer></div>" />

```erb
<%= render(Primer::Alpha::Dialog.new(
 title: "Title",
 description: "Description"
)) do |c| %>
  c.button { "Button 1" }
  c.button { "Button 2" }
  c.body do
    <em>Your custom content here</em>
  end
<% end %>
```