# Wiki

BookStack with HedgeDoc integration

## Usage

1. Copy `.env.example` to `.env` and edit the variables.

2. Run dev server

```bash
make run-dev

# If you don't want to see the logs from bookstack and hedgedoc, run
make run-dev ATTACH=

# Or just bookstack
make run-dev ATTACH=bookstack
```
