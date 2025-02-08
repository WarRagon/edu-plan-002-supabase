# edu-plan-002-supabase
A cross-platform example of user registration and login with Supabase using Python Flet, Flutter, and Tauri with both Svelte and React.

## IDE
visual studio code

# need to read
supabase-setting/REAME.md

# .env
```
app-flet, app_flutter

SUPABASE_URL="your SUPABASE_URL"
SUPABASE_KEY="your SUPABASE_KEY"

app-svelte, app-react

VITE_SUPABASE_URL="your SUPABASE_URL"
VITE_SUPABASE_KEY="your SUPABASE_KEY"
```

## app
### app-flet
pip install poetry

poetry install

python main.py

### app_flutter
flutter pub get

lib/main.dart

F5

### app_svelte, app_react
pnpm install

pnpm dev
