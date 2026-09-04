# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.1.0] - 2026-09-04
### :bug: Bug Fixes
- [`d7db114`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/d7db1141be8da65ecb1418b1be48fcc55dcb6a0a) - consolidate versions.tf, remove provider_meta, upgrade to azurerm >= 4.0 *(commit by [@anmolnagpal](https://github.com/anmolnagpal))*
- [`31c2e65`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/31c2e65a6d6929102d83a64f15fdc9e4893d958b) - replace version placeholder in example versions.tf with >= 4.0 *(commit by [@anmolnagpal](https://github.com/anmolnagpal))*

### :wrench: Chores
- [`dbc9853`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/dbc98537c2ed186c315e00858df9eccbe335062a) - **deps**: bump terraform-linters/setup-tflint from 4 to 6 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`c569a8c`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/c569a8c58062cdf704f98a7b8e3b711240818816) - **deps**: bump actions/checkout from 4 to 6 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`b8d7c41`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/b8d7c41f2e1e13859179614a2c9e9a504facc08a) - **deps**: bump hashicorp/setup-terraform from 3 to 4 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`aa6d85d`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/aa6d85d6eae82302bba515b756806e95677fe887) - add provider_meta for API usage tracking *(PR [#13](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/pull/13) by [@clouddrove-ci](https://github.com/clouddrove-ci))*
- [`aa9f8ea`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/aa9f8eae425c6f9459d2f4c232c8f58e81ab590d) - polish module with basic example, changelog, and version fixes *(PR [#14](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/pull/14) by [@clouddrove-ci](https://github.com/clouddrove-ci))*
- [`67278d1`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/67278d1e686cb98a2bb3ec9409b755b7eb79b398) - **deps**: bump terraform-az-modules/vnet/azurerm *(PR [#15](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/pull/15) by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`79dafa3`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/79dafa35d57cb2e846a08e182d5866e8ec12b77a) - **deps**: bump terraform-az-modules/subnet/azurerm *(PR [#16](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/pull/16) by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`8c90a8f`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/8c90a8f308c2eb1ff23ca735ee2db5631c94d3e6) - **deps**: bump terraform-az-modules/resource-group/azurerm *(PR [#17](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/pull/17) by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`e4613f8`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/e4613f88d3e143d67aa444abeef53c8350d5ec1d) - **deps**: bump actions/checkout from 3 to 6 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`bbb0117`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/bbb0117793e30376775130a7a69e40f1f8805136) - **deps**: bump actions/checkout from 6 to 7 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`27df6e7`](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/commit/27df6e77e3e706a3b8ad2e20597d146b65f3b79a) - **deps**: bump terraform-az-modules/subnet/azurerm *(PR [#24](https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/pull/24) by [@dependabot[bot]](https://github.com/apps/dependabot))*


## [1.0.2] - 2026-03-20

### Changes
- Add provider_meta for API usage tracking
- Add terraform tests and pre-commit CI workflow
- Add SECURITY.md, CONTRIBUTING.md, .releaserc.json
- Standardize pre-commit to antonbabenko v1.105.0
- Set provider: none in tf-checks for validate-only CI
- Bump required_version to >= 1.10.0
[v1.1.0]: https://github.com/terraform-az-modules/terraform-azurerm-vmss-agent/compare/v1.0.2...v1.1.0
