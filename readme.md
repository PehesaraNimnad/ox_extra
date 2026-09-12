# ox_extra

A community-edited and updated version of **ox_compact**, focused on improving compatibility with newer versions of **ox_lib** and extending the resource with **ox_inventory** support.

> [!WARNING]
> **ox_inventory integration is currently in BETA.**
>
> This functionality is still being tested and improved. Some features, edge cases, or compatibility issues may remain.

---

## 📖 About

**ox_extra** is a modified and updated version of the original **ox_compact** resource.

The original `ox_compact` project was created as a conversion of:

- `qb-input`
- `qb-menu`

to `ox_lib`.

This version continues that concept by updating the resource for newer versions of `ox_lib`, adapting existing functionality to newer APIs, fixing compatibility issues, and adding experimental support for `ox_inventory`.

I am **not the original author or owner** of the original `ox_compact` resource.

The original source code, concept, and implementation belong to the original author(s). This repository contains community-made modifications, updates, compatibility changes, and additional functionality.

---

## ✨ Features

### ox_lib Support

- Updated compatibility for `ox_lib`
- Updated for `ox_lib v3.39.0`
- Adapted existing functionality to newer `ox_lib` APIs
- Fixed compatibility issues caused by newer `ox_lib` updates
- Maintains the original resource structure where possible
- Designed to make migration from older QB UI resources easier

### qb-input Conversion

`ox_extra` provides an `ox_lib` based alternative for functionality previously handled by:

```text
qb-input
```

The goal is to allow resources using `qb-input` functionality to transition toward the OX ecosystem with minimal changes where possible.

### qb-menu Conversion

`ox_extra` also provides an `ox_lib` based alternative for functionality previously handled by:

```text
qb-menu
```

This helps existing resources move away from the older QB menu system while using the newer `ox_lib` UI functionality.

### ox_inventory Support

This version also includes experimental integration with:

```text
ox_inventory
```

The integration is designed to improve compatibility between the resource and the OX inventory ecosystem.

> [!WARNING]
> `ox_inventory` support is currently **BETA**.
>
> Testing, improvements, and compatibility fixes are still ongoing.

---

## 🧩 Compatibility

| Resource | Status |
|----------|--------|
| `ox_lib` | ✅ Supported |
| `ox_lib v3.39.0` | ✅ Updated |
| `qb-input` conversion | ✅ Supported |
| `qb-menu` conversion | ✅ Supported |
| `ox_inventory` | 🧪 BETA |

---

## 📦 Requirements

Before installing `ox_extra`, make sure your server has the required dependencies.

### Required

- FiveM Server
- `ox_lib`

### Optional / Beta

- `ox_inventory`

`ox_inventory` is only required if you intend to use the inventory-related functionality.

---

## 🚀 Installation

### 1. Download

Download or clone this repository into your FiveM resources directory.

Example:

```text
resources/
└── [ox]/
    └── ox_extra/
```

### 2. Start Dependencies

Make sure `ox_lib` is started before `ox_extra`.

Example:

```cfg
ensure ox_lib
ensure ox_extra
```

If you are using the `ox_inventory` integration:

```cfg
ensure ox_lib
ensure ox_inventory
ensure ox_extra
```

---

## ⚙️ Load Order

For the best compatibility, make sure your resources are started in the correct order.

Recommended:

```cfg
ensure ox_lib
ensure ox_inventory
ensure ox_extra
```

If you are not using the inventory integration:

```cfg
ensure ox_lib
ensure ox_extra
```

---

## 🔄 Migration

If your server currently uses:

```text
qb-input
qb-menu
```

you can use `ox_extra` as part of your migration toward the OX ecosystem.

The project is designed to provide similar functionality through:

```text
ox_lib
```

instead of relying on:

```text
qb-input
qb-menu
```

However, compatibility can depend on how individual resources were originally written.

Some resources may still require additional changes or compatibility adjustments.

---

## 🎒 ox_inventory Integration

One of the main additions in this version is experimental support for:

```text
ox_inventory
```

The purpose of this integration is to allow `ox_extra` to work more naturally with the OX inventory ecosystem.

### Beta Status

The `ox_inventory` integration is currently:

```text
BETA
```

This means it is still under active development and testing.

You may encounter:

- Compatibility issues
- Unexpected behavior
- Unsupported edge cases
- Resource-specific problems
- Missing functionality
- API-related issues after future OX updates

Please test the integration on a development server before deploying it to a production server.

---

## 🧪 Beta Testing

If you are testing the `ox_inventory` integration, please provide feedback when possible.

Useful information includes:

```text
FiveM Build:
ox_lib Version:
ox_inventory Version:
ox_extra Version:
Framework:
```

Also include:

```text
Error:
```

and:

```text
Steps to Reproduce:
1. ...
2. ...
3. ...
```

Logs from the FiveM client console or server console are also helpful.

---

## 🛠️ Changes

This version contains several updates and modifications compared to the original project.

### ox_lib Updates

- Updated compatibility with newer `ox_lib` versions
- Adapted existing functionality to newer APIs
- Updated deprecated or changed functionality where required
- Improved compatibility with modern OX resources
- Tested against `ox_lib v3.39.0`

### Compatibility Fixes

- Fixed issues caused by newer `ox_lib` changes
- Adjusted existing implementations for newer APIs
- Maintained original functionality where possible
- Improved compatibility with modern FiveM resources

### ox_inventory

- Added experimental `ox_inventory` compatibility
- Added inventory-related integration
- Improved interaction with the OX ecosystem
- Continued development and testing

---

## 🎯 Project Goals

The main goals of `ox_extra` are:

- Modernize the original `ox_compact` implementation
- Improve compatibility with newer `ox_lib` versions
- Make migration from `qb-input` easier
- Make migration from `qb-menu` easier
- Improve compatibility with the OX ecosystem
- Add `ox_inventory` support
- Maintain the original functionality wherever possible
- Provide a clean and practical compatibility resource for FiveM developers

---

## 💡 Why ox_extra?

The original `ox_compact` project provides a useful conversion layer for developers moving from QB UI resources to the OX ecosystem.

However, as `ox_lib` continues to evolve, older implementations may require updates to remain compatible.

`ox_extra` was created to continue that work by:

```text
ox_compact
     ↓
Updated compatibility
     ↓
New ox_lib APIs
     ↓
Additional OX integrations
     ↓
ox_extra
```

The project is intended to remain focused on compatibility and practical improvements rather than replacing the original project.

---

## 📁 Project Structure

The original resource was known as:

```text
ox_compact
```

This repository uses the new project name:

```text
ox_extra
```

The original project name is intentionally mentioned throughout this documentation to clearly identify the original project and give proper credit to its author.

---

## 👤 Original Author

The original `ox_compact` resource and source code belong to:

**zflabo**

Original repository:

https://github.com/zf-labo/ox_compat

Please support and respect the original author's work.

---

## ❤️ Credits

### Original Project

**Project Name:**

```text
ox_compact
```

**Original Author:**

```text
zflabo
```

**Original Repository:**

```text
https://github.com/zf-labo/ox_compat
```

The original source code and implementation belong to the original author(s).

### ox_extra

This repository contains community-made modifications including:

- Compatibility updates
- `ox_lib` API updates
- Bug fixes
- Adaptations
- Improvements
- `ox_inventory` integration
- Additional compatibility work

---

## ⚠️ Important Notice

This repository is **not the original `ox_compact` project**.

It is a modified/community-edited version based on the original project.

I do **not** claim ownership of the original `ox_compact` source code or original implementation.

The original project should always be credited to its original author(s).

If you are looking for the original resource, please visit:

https://github.com/zf-labo/ox_compat

---

## 📜 License

The original project's license applies to the original source code.

Any modifications or redistributed versions should comply with the original project's licensing requirements.

Please review the original repository and included license files before redistributing or using this project.

---

## 🐛 Bug Reports

If you find a problem with `ox_extra`, please open a GitHub issue.

When reporting an issue, please include as much information as possible.

### Recommended Information

```text
FiveM Build:
Framework:
ox_lib Version:
ox_inventory Version:
ox_extra Version:
Server OS:
```

### Problem

```text
Describe the problem here.
```

### Error

```text
Paste the complete error message here.
```

### Steps to Reproduce

```text
1. Start the server
2. Perform the required action
3. The error occurs
```

### Additional Information

Include any relevant:

- Client console logs
- Server console logs
- Screenshots
- Resource configuration
- Related resource information

Please avoid posting sensitive server information.

---

## 🔧 Development Status

`ox_extra` is currently under active development.

### Current Progress

- [x] `qb-input` conversion
- [x] `qb-menu` conversion
- [x] `ox_lib` compatibility updates
- [x] `ox_lib v3.39.0` compatibility
- [x] Compatibility fixes
- [x] Updated OX APIs
- [x] Initial `ox_inventory` integration
- [ ] Improve `ox_inventory` integration
- [ ] Expand inventory compatibility
- [ ] Additional compatibility testing
- [ ] Improve documentation
- [ ] Fix remaining edge cases
- [ ] Further performance improvements

---

## 🧪 Testing

Because `ox_extra` contains updated and experimental functionality, testing is highly recommended before using it on a live production server.

Especially when using:

```text
ox_inventory
```

Always test with the same versions of:

```text
ox_lib
ox_inventory
ox_extra
```

that are running on your production server.

---

## 🔮 Future Plans

Future development may include:

- Improved `ox_inventory` support
- Better compatibility with newer `ox_lib` versions
- Additional migration support
- Improved error handling
- Performance improvements
- Better documentation
- More extensive testing
- Additional compatibility fixes

The exact roadmap may change depending on community feedback and upstream OX changes.

---

## 🤝 Contributions

Contributions are welcome.

If you have improvements, compatibility fixes, or useful changes, feel free to contribute through GitHub.

When submitting changes:

- Keep the code clean
- Avoid unnecessary modifications
- Explain the purpose of the change
- Test the resource before submitting
- Include relevant compatibility information
- Make sure changes do not unnecessarily break existing functionality

---

## 📢 Feedback

Feedback is welcome, especially from developers testing:

```text
ox_lib
ox_inventory
qb-input migrations
qb-menu migrations
```

Bug reports and compatibility feedback help improve the project.

---

## 📌 Disclaimer

`ox_extra` is a community-edited project based on the original `ox_compact` resource.

It is not affiliated with, endorsed by, or officially maintained by the original `ox_compact` author unless explicitly stated.

All original work remains credited to the respective original author(s).

Please respect the original project's license and intellectual property.

---

## 📚 Credits Summary

| Project | Information |
|---------|-------------|
| Original Project | `ox_compact` |
| Original Author | `zflabo` |
| Original Repository | `zf-labo/ox_compat` |
| Current Project | `ox_extra` |
| `ox_lib` Support | `v3.39.0` |
| `ox_inventory` Support | 🧪 BETA |
| Purpose | QB UI → OX compatibility |

---

## ⭐ Support

If you find `ox_extra` useful, consider giving the repository a ⭐ on GitHub.

Your feedback, testing, bug reports, and contributions are appreciated.

---

# ox_extra

**An updated and extended community version of `ox_compact` for modern `ox_lib` compatibility and experimental `ox_inventory` support.**

> Original Project: `ox_compact`  
> Original Author: `zflabo`  
> Current Project: `ox_extra`  
> ox_inventory Integration: **BETA**
